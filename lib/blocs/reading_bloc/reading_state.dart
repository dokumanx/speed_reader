part of 'reading_bloc.dart';

enum Reading { initial, started, running, paused, finished }

@freezed
class ReadingState with _$ReadingState {
  const factory ReadingState({
    @ignore @Default(Reading.initial) Reading reading,
    @ignore @Default([]) List<String> words,
    @ignore @Default(0) int index,
    @ignore @Default('') String currentText,
    @Default(1) int wordsDisplayed,
    @Default(1) double fontScale,
    @Default(100) int wpm,
    @colorConvertor @Default(Colors.black) Color textColor,
  }) = _ReadingState;

  factory ReadingState.fromJson(Map<String, dynamic> json) =>
      _$ReadingStateFromJson(json);
}

const ignore = JsonKey(includeToJson: false, includeFromJson: false);
