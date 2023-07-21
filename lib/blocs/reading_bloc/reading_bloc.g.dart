// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReadingState _$$_ReadingStateFromJson(Map<String, dynamic> json) =>
    _$_ReadingState(
      wordsDisplayed: json['wordsDisplayed'] as int? ?? 1,
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1,
      wpm: json['wpm'] as int? ?? 100,
      textColor: json['textColor'] == null
          ? Colors.black
          : colorConvertor.fromJson(json['textColor'] as int),
    );

Map<String, dynamic> _$$_ReadingStateToJson(_$_ReadingState instance) =>
    <String, dynamic>{
      'wordsDisplayed': instance.wordsDisplayed,
      'fontScale': instance.fontScale,
      'wpm': instance.wpm,
      'textColor': colorConvertor.toJson(instance.textColor),
    };
