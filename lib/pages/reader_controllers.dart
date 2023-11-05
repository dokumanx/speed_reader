import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';

class ReaderControllers extends StatelessWidget {
  const ReaderControllers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () =>
              context.read<ReadingBloc>().add(const ReadingEvent.reset()),
          icon: const Icon(
            Icons.restart_alt_sharp,
          ),
        ),
        IconButton(
          onPressed: () =>
              context.read<ReadingBloc>().add(const ReadingEvent.start()),
          icon: const Icon(
            Icons.play_arrow,
          ),
        ),
        IconButton(
          onPressed: () =>
              context.read<ReadingBloc>().add(const ReadingEvent.pause()),
          icon: const Icon(
            Icons.pause,
          ),
        ),
      ],
    );
  }
}
