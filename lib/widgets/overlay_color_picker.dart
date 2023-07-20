import 'package:flutter/material.dart';
import 'package:speed_reader/constants/tailwind_colors.dart';
import 'package:speed_reader/extensions/theme_extension.dart';
import 'package:speed_reader/spacing/spacing.dart';

class OverlayColorPicker extends StatelessWidget {
  OverlayColorPicker({
    required this.onTap,
    required this.selectedColor,
    super.key,
  });

  final ValueChanged<Color> onTap;
  final Color selectedColor;

  final List<Color> colors = [
    TailwindColors.red,
    TailwindColors.orange,
    TailwindColors.amber,
    TailwindColors.yellow,
    TailwindColors.lime,
    TailwindColors.green,
    TailwindColors.emerald,
    TailwindColors.teal,
    TailwindColors.cyan,
    TailwindColors.lightBlue,
    TailwindColors.blue,
    TailwindColors.indigo,
    TailwindColors.purple,
    TailwindColors.fuchsia,
    TailwindColors.pink,
    TailwindColors.rose,
    TailwindColors.warmGray,
    TailwindColors.trueGray,
    TailwindColors.blueGray,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: ColoredBox(
          color: context.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xlg),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 45,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];

                return GestureDetector(
                  onTap: () => onTap(color),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(180),
                      color: color,
                    ),
                    child: selectedColor == color
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: AppSpacing.xlg,
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
