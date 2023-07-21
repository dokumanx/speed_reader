import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

class _ColorConverter extends JsonConverter<Color, int> {
  const _ColorConverter();

  @override
  Color fromJson(int value) {
    return Color(value);
  }

  @override
  int toJson(Color color) {
    return color.value;
  }
}

const colorConvertor = _ColorConverter();
