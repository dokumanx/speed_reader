part of 'reading_bloc.dart';

enum Reading { initial, started, running, paused, finished }

@freezed
class ReadingState with _$ReadingState {
  const factory ReadingState({
    @Default(Reading.initial) Reading reading,
    @Default([]) List<String> words,
    @Default(0) int index,
    @Default('') String currentText,
    @Default(1) int wordsDisplayed,
    @Default(1) double fontScale,
    @Default(100) int wpm,
    @Default(Colors.black) Color textColor,
  }) = _ReadingState;
}
