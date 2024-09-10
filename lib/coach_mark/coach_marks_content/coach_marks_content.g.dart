// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_marks_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachMarksContent _$CoachMarksContentFromJson(Map<String, dynamic> json) =>
    CoachMarksContent(
      coachMarks: (json['coachMarks'] as List<dynamic>?)
          ?.map((e) => CoachMark.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CoachMarksContentToJson(CoachMarksContent instance) =>
    <String, dynamic>{
      'coachMarks': instance.coachMarks,
    };
