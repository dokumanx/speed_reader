String totalReadingTime({required List<String> words, required int wpm}) {
  final seconds = words.length / (wpm / 60);

  final duration = Duration(seconds: seconds.toInt());
  return '${duration.inMinutes} min';
}