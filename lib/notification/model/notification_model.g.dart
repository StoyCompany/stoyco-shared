// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      guid: json['guid'] as String?,
      itemId: json['itemId'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String?,
      text: json['text'] as String?,
      image: json['image'] as String?,
      type: (json['type'] as num?)?.toInt(),
      color: json['color'] as String?,
      isReaded: json['isReaded'] as bool?,
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'userId': instance.userId,
      'title': instance.title,
      'text': instance.text,
      'image': instance.image,
      'type': instance.type,
      'color': instance.color,
      'isReaded': instance.isReaded,
      'createAt': instance.createAt?.toIso8601String(),
      'guid': instance.guid,
    };
