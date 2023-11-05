import 'package:flutter/material.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/extensions/show_modal_extensions.dart';
import 'package:speed_reader/extensions/theme_extension.dart';
import 'package:speed_reader/spacing/app_spacing.dart';
import 'package:speed_reader/widgets/overlay_color_picker.dart';

class TextColorController extends StatelessWidget {
  const TextColorController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReadingBloc, ReadingState, Color>(
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
    );
  }
}
