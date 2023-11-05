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

class RegularReaderPage extends StatelessWidget {
  const RegularReaderPage({super.key});

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
                    final highlightedText = state.highlightedText;

                    return HtmlWidget(
                      '<div class="container"> <span class="font">$highlightedText</span></div>',
                      enableCaching: false,
                      customStylesBuilder: (element) {
                        final fontSize = 30 * fontScale;
                        if (element.classes.contains('font')) {
                          return {
                            'font-size': '${fontSize}px',
                            'color': textColor,
                            'font-weight': '500',
                          };
                        } else if (element.classes.contains('highlighted')) {
                          return {
                            'font-size': '${fontSize}px',
                            'color': Colors.black87.toRGBString(1),
                            'background-color': Colors.blue.toRGBString(.6),
                            'border-radius': '4px',
                            'font-weight': '500',
                          };
                        } else if (element.classes.contains('container')) {
                          return {
                            'text-align': 'justify',
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
}
