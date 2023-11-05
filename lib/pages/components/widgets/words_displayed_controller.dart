import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';

class WordsDisplayedController extends StatelessWidget {
  const WordsDisplayedController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReadingBloc, ReadingState, int>(
      selector: (state) {
        return state.wordsDisplayed;
      },
      builder: (context, wordsDisplayed) {
        return Slider(
          min: 1,
          max: 4,
          value: wordsDisplayed.toDouble(),
          onChanged: (double value) {
            context
                .read<ReadingBloc>()
                .add(ReadingEvent.update(wordsDisplayed: value.toInt()));
          },
        );
      },
    );
  }
}
