// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_mark_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachMarkData _$CoachMarkDataFromJson(Map<String, dynamic> json) =>
    CoachMarkData(
      title: json['title'] as String?,
      description: json['description'] as String?,
      button: json['button'] as String?,
      type: json['type'] as String?,
      step: (json['step'] as num?)?.toInt(),
      enableClose: json['enableClose'] as bool?,
      enableNext: json['enableNext'] as bool?,
    );

Map<String, dynamic> _$CoachMarkDataToJson(CoachMarkData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'button': instance.button,
      'type': instance.type,
      'step': instance.step,
      'enableClose': instance.enableClose,
      'enableNext': instance.enableNext,
    };
