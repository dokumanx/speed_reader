import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/constants/tailwind_colors.dart';
import 'package:speed_reader/extensions/theme_extension.dart';
import 'package:speed_reader/pages/components/widgets/text_color_controller.dart';
import 'package:speed_reader/pages/components/widgets/text_font_scale_controllers.dart';
import 'package:speed_reader/pages/components/widgets/total_reading_timer.dart';
import 'package:speed_reader/pages/components/widgets/words_displayed_controller.dart';
import 'package:speed_reader/pages/components/widgets/wpm_controller.dart';
import 'package:speed_reader/pages/reader_controllers.dart';
import 'package:speed_reader/widgets/square_container.dart';

class SpeedReaderPage extends StatefulWidget {
  const SpeedReaderPage({super.key});

  @override
  State<SpeedReaderPage> createState() => _SpeedReaderPageState();
}

class _SpeedReaderPageState extends State<SpeedReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SquareContainer(
                  color: TailwindColors.fuchsia.withOpacity(.3),
                  dimension: 35,
                  child: const Icon(LucideIcons.arrowLeft),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextColorController(),
                SizedBox(
                  width: 10,
                ),
                TextFontScaleControllers(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const WordsDisplayedController(),
            const WpmController(),
            const SizedBox(
              height: 20,
            ),
            const TotalReadingTimer(),
            Expanded(
              child: Align(
                child: BlocBuilder<ReadingBloc, ReadingState>(
                  buildWhen: (previous, current) {
                    return previous.textColor != current.textColor ||
                        previous.fontScale != current.fontScale ||
                        previous.wordsDisplayed != current.wordsDisplayed ||
                        previous.currentText != current.currentText ||
                        previous.reading != current.reading;
                  },
                  builder: (context, state) {
                    final fontScale = state.fontScale;

                    final textColor = state.textColor.toRGBString(1);
                    final currentText = state.currentText;

                    return HtmlWidget(
                      '<div class="container">$currentText</div>',
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
            const ReaderControllers(),
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
    final saccade0 = saccade + 1;

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
    for (var i = 0; i < substrings.length; i += saccade0 * 2) {
      bool division;
      if (index == 0 && saccade0 == 0) {
        division = true;
      } else {
        division = index % saccade0 == 0;
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
