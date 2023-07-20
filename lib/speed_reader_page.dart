import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/extensions/show_modal_extensions.dart';
import 'package:speed_reader/extensions/theme_extension.dart';
import 'package:speed_reader/spacing/spacing.dart';
import 'package:speed_reader/widgets/overlay_color_picker.dart';
import 'package:speed_reader/widgets/square_container.dart';

class SpeedReaderPage extends StatefulWidget {
  const SpeedReaderPage({super.key});

  @override
  State<SpeedReaderPage> createState() => _SpeedReaderPageState();
}

class _SpeedReaderPageState extends State<SpeedReaderPage> {
  @override
  void initState() {
    super.initState();
  }

  String _totalReadingTime({required List<String> words, required int wpm}) {
    final seconds = words.length / (wpm / 60);

    final duration = Duration(seconds: seconds.toInt());
    return '${duration.inMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocSelector<ReadingBloc, ReadingState, Color>(
                  selector: (state) => state.textColor,
                  builder: (context, textColor) {
                    return GestureDetector(
                      onTap: () {
                        OverlayColorPicker(
                          selectedColor: textColor,
                          onTap: (value) {
                            context
                                .read<ReadingBloc>()
                                .add(ReadingEvent.update(textColor: value));
                            Navigator.of(context).pop();
                          },
                        ).showAlert(context);
                      },
                      child: Container(
                        width: AppSpacing.spaceUnit * 1.75,
                        height: AppSpacing.spaceUnit * 1.75,
                        decoration: ShapeDecoration(
                          color: textColor,
                          shape: CircleBorder(
                            side: BorderSide(
                              color: context.colorScheme.onSurface,
                              width: AppSpacing.spaceUnit * 0.08,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                SquareContainer(
                  dimension: 35,
                  iconColor: Colors.black,
                  color: Colors.white,
                  borderColor: Colors.black,
                  borderWidth: 0.5,
                  child: Text(
                    'Aa',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () {
                    context.read<ReadingBloc>().decreaseFontScale();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                SquareContainer(
                  dimension: 35,
                  iconColor: Colors.black,
                  color: Colors.white,
                  borderColor: Colors.black,
                  borderWidth: 0.5,
                  child: Text(
                    'Aa',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: () {
                    context.read<ReadingBloc>().increaseFontScale();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            BlocSelector<ReadingBloc, ReadingState, int>(
              selector: (state) {
                return state.wordsDisplayed;
              },
              builder: (context, wordsDisplayed) {
                return Slider(
                  min: 1,
                  max: 4,
                  value: wordsDisplayed.toDouble(),
                  onChanged: (double value) {
                    context.read<ReadingBloc>().add(
                        ReadingEvent.update(wordsDisplayed: value.toInt()));
                  },
                );
              },
            ),
            BlocBuilder<ReadingBloc, ReadingState>(
              buildWhen: (previous, current) {
                return previous.wpm != current.wpm;
              },
              builder: (context, state) {
                final wpm = state.wpm;
                final words = state.words;

                return Column(
                  children: [
                    Text(
                      '$wpm wpm',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Slider(
                      min: 40,
                      max: 1000,
                      divisions: ((1000 - 40) / 10).round(),
                      value: wpm.clamp(40, 1000).toDouble(),
                      onChanged: (double value) {
                        context.read<ReadingBloc>().add(
                              ReadingEvent.update(wpm: value.toInt()),
                            );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _totalReadingTime(wpm: wpm, words: words),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: Align(
                child: BlocBuilder<ReadingBloc, ReadingState>(
                  buildWhen: (previous, current) {
                    return previous.textColor != current.textColor ||
                        previous.fontScale != current.fontScale ||
                        previous.wordsDisplayed != current.wordsDisplayed ||
                        previous.currentText != current.currentText;
                  },
                  builder: (context, state) {
                    final fontScale = state.fontScale;

                    final textColor = state.textColor.toRGBString(1);
                    final currentText = state.currentText;

                    return HtmlWidget(
                      '<div class="container"><span class="words">$currentText</span></div>',
                      enableCaching: false,
                      customStylesBuilder: (element) {
                        final fontSize = 30 * fontScale;
                        if (element.classes.contains('words')) {
                          return {
                            'font-size': '${fontSize}px',
                            'color': textColor,
                            'font-weight': '500',
                          };
                        } else if (element.classes.contains('container')) {
                          return {
                            'text-align': 'center',
                            'padding-left': '20px',
                            'padding-right': '20px',
                          };
                        }
                        return null;
                      },
                      // textStyle:
                      //     Theme.of(context).textTheme.headlineMedium?.copyWith(
                      //           fontWeight: FontWeight.w500,
                      //         ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => context
                      .read<ReadingBloc>()
                      .add(const ReadingEvent.reset()),
                  icon: const Icon(
                    Icons.restart_alt_sharp,
                  ),
                ),
                IconButton(
                  onPressed: () => context
                      .read<ReadingBloc>()
                      .add(const ReadingEvent.start()),
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                ),
                IconButton(
                  onPressed: () => context
                      .read<ReadingBloc>()
                      .add(const ReadingEvent.pause()),
                  icon: const Icon(
                    Icons.pause,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String convertToBionic(String word,
      {required int index,
      int fixation = 2,
      int saccade = 1,
      double opacity = 1.0}) {
    final _saccade = saccade + 1;

    // Determine the maximum number of non-bold characters to be highlighted based on the length of the input word and the fixation strength
    int maxNonBoldChars;
    if (word.length <= 4) {
      maxNonBoldChars = 1 + fixation;
    } else if (word.length <= 12) {
      maxNonBoldChars = 2 + fixation;
    } else if (word.length <= 16) {
      maxNonBoldChars = 3 + fixation;
    } else if (word.length <= 24) {
      maxNonBoldChars = 4 + fixation;
    } else if (word.length <= 29) {
      maxNonBoldChars = 5 + fixation;
    } else if (word.length <= 35) {
      maxNonBoldChars = 6 + fixation;
    } else if (word.length <= 42) {
      maxNonBoldChars = 7 + fixation;
    } else if (word.length <= 48) {
      maxNonBoldChars = 8 + fixation;
    } else {
      maxNonBoldChars = 9 + fixation;
    }

    // Divide the input word into substrings based on special characters (excluding dashes) if they exist in the word
    final substrings = <String>[];
    final currentSubstring = StringBuffer();
    for (var i = 0; i < word.length; i++) {
      if (word[i].contains(RegExp('[a-zA-Z0-9]'))) {
        currentSubstring.write(word[i]);
      } else if (word[i] == '-') {
        substrings.add(currentSubstring.toString());
        currentSubstring.clear();
        substrings.add('-');
      }
    }
    substrings.add(currentSubstring.toString());

    // Replace the non-bold characters with span tags in the substrings that exceed the maximum number of non-bold characters
    for (var i = 0; i < substrings.length; i += _saccade * 2) {
      bool division;
      if (index == 0 && _saccade == 0) {
        division = true;
      } else {
        division = index % _saccade == 0;
      }

      if (division && substrings[i].length > maxNonBoldChars) {
        final numNonBoldChars = substrings[i].length - maxNonBoldChars;
        final boldSubstring =
            '<span style="font-weight:bold;opacity:${opacity.toStringAsFixed(1)};">${substrings[i].substring(0, numNonBoldChars)}</span>';
        substrings[i] =
            boldSubstring + substrings[i].substring(numNonBoldChars);
      }
      index++;
    }

    // Concatenate the substrings and return the resulting bionic word
    final result = StringBuffer();
    for (var i = 0; i < substrings.length; i++) {
      if (substrings[i].isNotEmpty) {
        result.write(substrings[i]);
      }
    }
    return result.toString();
  }
}
