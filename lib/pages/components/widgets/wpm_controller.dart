import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';

class WpmController extends StatelessWidget {
  const WpmController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
      buildWhen: (previous, current) {
        return previous.wpm != current.wpm;
      },
      builder: (context, state) {
        final wpm = state.wpm;

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
          ],
        );
      },
    );
  }
}
