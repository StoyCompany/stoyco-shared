// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachMark _$CoachMarkFromJson(Map<String, dynamic> json) => CoachMark(
      type: json['type'] as String?,
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => CoachMarkData.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalizationModal: json['finalizationModal'] == null
          ? null
          : CoachMarkData.fromJson(
              json['finalizationModal'] as Map<String, dynamic>),
      initializationModal: json['initializationModal'] == null
          ? null
          : CoachMarkData.fromJson(
              json['initializationModal'] as Map<String, dynamic>),
      isCompleted: json['isCompleted'] as bool? ?? false,
      currentStep: (json['currentStep'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CoachMarkToJson(CoachMark instance) => <String, dynamic>{
      'type': instance.type,
      'isCompleted': instance.isCompleted,
      'initializationModal': instance.initializationModal,
      'finalizationModal': instance.finalizationModal,
      'content': instance.content,
      'currentStep': instance.currentStep,
    };
