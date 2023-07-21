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
  ReadingBloc() : super(const ReadingState()) {
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

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }

  String _getWordsInRange({int? index, int? wordsDisplayed}) {
    final endIndex =
        (index ?? state.index) + (wordsDisplayed ?? state.wordsDisplayed);

    late final String currentText;
    if (endIndex > state.words.length) {
      currentText = state.words.sublist(index ?? state.index).join(' ');
    } else {
      currentText =
          state.words.sublist(index ?? state.index, endIndex).join(' ');
    }

    return currentText;
  }

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
    if (endIndex > words.length) {
      currentText = words.sublist(index).join(' ');
      index = words.length - 1;
    } else {
      currentText = words.sublist(index, endIndex).join(' ');
    }
    emit(
      state.copyWith(
        words: words,
        index: index,
        wordsDisplayed: wordsDisplayed,
        fontScale: fontScale,
        textColor: textColor,
        wpm: wpm,
        currentText: currentText,
      ),
    );
    if (state.reading == Reading.running) {
      add(const ReadingEvent.pause());
      add(const ReadingEvent.start());
    }
  }

  void _resetReading(_Reset value, Emitter<ReadingState> emit) {
    _cancelTimer();
    emit(
      state.copyWith(
        index: 0,
        currentText: _getWordsInRange(index: 0),
        reading: Reading.initial,
      ),
    );
  }

  void _stopReading(_Stop value, Emitter<ReadingState> emit) {
    _cancelTimer();
    emit(state.copyWith(reading: Reading.finished));
  }

  void decreaseFontScale() {
    add(ReadingEvent.update(fontScale: state.fontScale - 0.1));
  }

  void increaseFontScale() {
    add(ReadingEvent.update(fontScale: state.fontScale + 0.1));
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
