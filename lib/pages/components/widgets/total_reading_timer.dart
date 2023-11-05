import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/core/utils/helpers.dart';

class TotalReadingTimer extends StatelessWidget {
  const TotalReadingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
      buildWhen: (previous, current) {
        return previous.wpm != current.wpm;
      },
      builder: (context, state) {
        final wpm = state.wpm;
        final words = state.words;

        return Text(
          totalReadingTime(wpm: wpm, words: words),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        );
      },
    );
  }
}
