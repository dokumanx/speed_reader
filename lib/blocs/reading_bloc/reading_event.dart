part of 'reading_bloc.dart';

@freezed
class ReadingEvent with _$ReadingEvent {
  const factory ReadingEvent.start() = _Start;

  const factory ReadingEvent.pause() = _Pause;

  const factory ReadingEvent.stop() = _Stop;

  const factory ReadingEvent.reset() = _Reset;

  const factory ReadingEvent.update({
    List<String>? words,
    int? index,
    int? wordsDisplayed,
    double? fontScale,
    int? wpm,
    Color? textColor,
  }) = _Update;
}
