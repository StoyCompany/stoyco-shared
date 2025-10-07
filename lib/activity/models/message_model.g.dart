// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      messageId: json['messageId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      category: json['category'] as String?,
      isRead: json['isRead'] as bool?,
      seen: json['seen'] as bool?,
      linkText: json['linkText'] as String?,
      linkUrl: json['linkUrl'] as String?,
      route: json['route'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'messageId': instance.messageId,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'isRead': instance.isRead,
      'seen': instance.seen,
      'linkText': instance.linkText,
      'linkUrl': instance.linkUrl,
      'route': instance.route,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };
