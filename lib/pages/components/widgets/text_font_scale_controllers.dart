import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/widgets/square_container.dart';

class TextFontScaleControllers extends StatelessWidget {
  const TextFontScaleControllers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
    );
  }
}
