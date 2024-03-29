import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stoyco_shared/extensions/hex_color.dart';
import 'package:stoyco_shared/notification/model/notification_type.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 5)
class NotificationModel extends Equatable {
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String?,
        guid: json['guid'] as String?,
        itemId: json['itemId'] as String?,
        userId: json['userId'] as String?,
        title: json['title'] as String?,
        text: json['text'] as String?,
        image: json['image'] as String?,
        type: int.tryParse(json['type'].toString()),
        color: json['color'] as String?,
        isReaded: json['isReaded'] is bool
            ? json['isReaded'] as bool
            : json['isReaded'] == 'true',
        createAt: json['createAt'] == null
            ? null
            : DateTime.tryParse(json['createAt'] as String),
      );

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    NotificationModel data = NotificationModel.fromJson(message.data);
    String? imageUrl;
    if (Platform.isAndroid) {
      imageUrl = message.notification?.android?.imageUrl;
    } else if (Platform.isIOS) {
      imageUrl = message.notification?.apple?.imageUrl;
    }
    data = data.copyWith(
      title: message.notification?.title,
      text: message.notification?.body,
      image: imageUrl,
    );
    return data;
  }

  const NotificationModel({
    this.id,
    this.guid,
    this.itemId,
    this.userId,
    this.title,
    this.text,
    this.image,
    this.type,
    this.color,
    this.isReaded,
    this.createAt,
  });
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? itemId;
  @HiveField(2)
  final String? userId;
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final String? text;
  @HiveField(5)
  final String? image;
  @HiveField(6)
  final int? type;
  @HiveField(7)
  final String? color;
  @HiveField(8)
  final bool? isReaded;
  @HiveField(9)
  final DateTime? createAt;
  @HiveField(10)
  final String? guid;

  Color get materialColor =>
      color == null ? Colors.transparent : HexColor(color!);

  NotificationType get enumType => NotificationType.fromInt(type);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'guid': guid,
        'itemId': itemId,
        'userId': userId,
        'title': title,
        'text': text,
        'image': image,
        'type': type,
        'color': color,
        'isReaded': isReaded,
        'createAt': createAt?.toIso8601String(),
      };

  NotificationModel copyWith({
    String? id,
    String? guid,
    String? itemId,
    String? userId,
    String? title,
    String? text,
    String? image,
    int? type,
    String? color,
    bool? isReaded,
    DateTime? createAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        guid: guid ?? this.guid,
        itemId: itemId ?? this.itemId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        text: text ?? this.text,
        image: image ?? this.image,
        type: type ?? this.type,
        color: color ?? this.color,
        isReaded: isReaded ?? this.isReaded,
        createAt: createAt ?? this.createAt,
      );

  @override
  List<Object?> get props => [
        id,
        guid,
        itemId,
        userId,
        title,
        text,
        image,
        type,
        color,
        isReaded,
        createAt,
      ];
}
