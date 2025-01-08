import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/extensions/hex_color.dart';
import 'package:stoyco_shared/notification/model/notification_type.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends Equatable {
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
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
  final String? id;
  final String? itemId;
  final String? userId;
  final String? title;
  final String? text;
  final String? image;
  final int? type;
  final String? color;
  final bool? isReaded;
  final DateTime? createAt;
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
