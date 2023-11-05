import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:speed_reader/blocs/color_convertor.dart';

part 'reading_bloc.freezed.dart';

part 'reading_bloc.g.dart';

part 'reading_event.dart';

part 'reading_state.dart';

class ReadingBloc extends HydratedBloc<ReadingEvent, ReadingState> {
  ReadingBloc({
    this.maxFontScale = 1.5,
    this.minFontScale = 0.7,
  }) : super(const ReadingState()) {
    on<ReadingEvent>((event, emit) {
      event.map(
        start: (value) => _startReading(value, emit),
        pause: (value) => _pauseReading(value, emit),
        reset: (value) => _resetReading(value, emit),
        update: (value) => _updateReading(value, emit),
        stop: (value) => _stopReading(value, emit),
      );
    });
  }

  Timer? _timer;
  final double maxFontScale;
  final double minFontScale;

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }

  String _getWordsInRange({
    int? index,
    int? wordsDisplayed,
    bool highlighted = false,
  }) {
    final endIndex =
        (index ?? state.index) + (wordsDisplayed ?? state.wordsDisplayed);

    late final String currentText;
    if (endIndex > state.words.length) {
      currentText = state.words.sublist(index ?? state.index).join(' ');
    } else {
      currentText =
          state.words.sublist(index ?? state.index, endIndex).join(' ');
    }

    if (highlighted) {
      return highlightedTextHtml(currentText);
    } else {
      return currentTextHtml(currentText);
    }
  }

  String currentTextHtml(String text) => '<span class="words">$text</span>';

  String highlightedTextHtml(String text) =>
      '<span class="highlighted">$text</span>';

  Duration _estimateDuration(double wpm) {
    return Duration(milliseconds: ((60 / wpm) * 1000).round());
  }

  Timer createTimer(int wpm, void Function(Timer timer) callback) {
    if (_timer == null) {
      final actualWpm = wpm / state.wordsDisplayed;
      final duration = _estimateDuration(actualWpm);
      return Timer.periodic(duration, (timer) {
        callback(timer);
      });
    } else {
      return _timer!;
    }
  }

  FutureOr<void> _startReading(_Start value, Emitter<ReadingState> emit) {
    emit(state.copyWith(reading: Reading.running));
    _timer = createTimer(state.wpm, (timer) {
      if (state.index < state.words.length - 1) {
        final newIndex = state.index + state.wordsDisplayed;
        add(ReadingEvent.update(
          index: newIndex,
        ));
      } else {
        add(const ReadingEvent.stop());
      }
    });
  }

  void _pauseReading(_Pause value, Emitter<ReadingState> emit) {
    _cancelTimer();
    emit(state.copyWith(reading: Reading.paused));
  }

  void _updateReading(_Update value, Emitter<ReadingState> emit) {
    final words = value.words ?? state.words;
    var index = value.index ?? state.index;
    final wpm = value.wpm ?? state.wpm;
    final wordsDisplayed = value.wordsDisplayed ?? state.wordsDisplayed;
    final fontScale = value.fontScale ?? state.fontScale;
    final textColor = value.textColor ?? state.textColor;

    final endIndex = index + wordsDisplayed;
    late final String currentText;
    late final String highlightedText;
    if (endIndex > words.length) {
      currentText = words.sublist(index).join(' ');
      index = words.length - 1;
      final tempWords = List.of(words);

      // ignore: cascade_invocations
      tempWords.replaceRange(
        index,
        words.length,
        highlightedTextHtml(currentText).split(' '),
      );

      highlightedText = tempWords.join(' ');
    } else {
      currentText = words.sublist(index, endIndex).join(' ');
      final tempWords = List.of(words);

      // ignore: cascade_invocations
      tempWords.replaceRange(
        index,
        endIndex,
        highlightedTextHtml(currentText).split(' '),
      );

      highlightedText = tempWords.join(' ');
    }
    emit(
      state.copyWith(
        words: words,
        index: index,
        wordsDisplayed: wordsDisplayed,
        fontScale: fontScale,
        textColor: textColor,
        wpm: wpm,
        currentText: currentTextHtml(currentText),
        highlightedText: highlightedText,
      ),
    );
    if (state.reading == Reading.running) {
      add(const ReadingEvent.pause());
      add(const ReadingEvent.start());
    }
  }

  void _resetReading(_Reset value, Emitter<ReadingState> emit) {
    _cancelTimer();

    final wordsDisplayed = state.wordsDisplayed;
    final words = state.words;
    const index = 0;

    final tempWords = List.of(words);

    // ignore: cascade_invocations
    tempWords.replaceRange(
      index,
      wordsDisplayed,
      highlightedTextHtml(_getWordsInRange(index: index)).split(' '),
    );
    final highlightedText = tempWords.join(' ');

    emit(
      state.copyWith(
        index: index,
        currentText: _getWordsInRange(index: index),
        highlightedText: highlightedText,
        reading: Reading.initial,
      ),
    );
  }

  void _stopReading(_Stop value, Emitter<ReadingState> emit) {
    _cancelTimer();
    emit(state.copyWith(reading: Reading.finished));
  }

  void decreaseFontScale() {
    final updatedScale = state.fontScale - 0.1;

    if (updatedScale < minFontScale) {
      return;
    }

    add(ReadingEvent.update(fontScale: updatedScale));
  }

  void increaseFontScale() {
    final updatedScale = state.fontScale + 0.1;

    if (updatedScale > maxFontScale) {
      return;
    }

    add(ReadingEvent.update(fontScale: updatedScale));
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  ReadingState? fromJson(Map<String, dynamic> json) {
    return ReadingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ReadingState state) {
    return state.toJson();
  }
}
