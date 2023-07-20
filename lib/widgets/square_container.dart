import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SquareContainer extends StatelessWidget {
  const SquareContainer({
    required this.child,
    super.key,
    this.color,
    this.iconColor,
    this.dimension,
    this.borderWidth,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final Color? iconColor;
  final double? dimension;
  final double? borderWidth;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension ?? 25,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
          color: color,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              onTap?.call();
              await HapticFeedback.mediumImpact();
            },
            child: child,
          ),
        ),
      ),
    );
  }
}
