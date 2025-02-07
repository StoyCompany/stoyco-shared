// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoMetadata _$VideoMetadataFromJson(Map<String, dynamic> json) =>
    VideoMetadata(
      id: json['id'] as String?,
      videoId: json['videoId'] as String?,
      createdBy: json['createdBy'] as String?,
      stoyCoins: (json['stoyCoins'] as num?)?.toInt(),
      shared: (json['shared'] as num?)?.toInt(),
      likes: (json['likes'] as num?)?.toInt(),
      dislikes: (json['dislikes'] as num?)?.toInt(),
      totalScore: (json['totalScore'] as num?)?.toInt(),
      enableReward: json['enableReward'] as bool?,
      rewardPoints: (json['rewardPoints'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      publicationDate: json['publicationDate'] == null
          ? null
          : DateTime.parse(json['publicationDate'] as String),
    );

Map<String, dynamic> _$VideoMetadataToJson(VideoMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'createdBy': instance.createdBy,
      'stoyCoins': instance.stoyCoins,
      'shared': instance.shared,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'totalScore': instance.totalScore,
      'enableReward': instance.enableReward,
      'rewardPoints': instance.rewardPoints,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'publicationDate': instance.publicationDate?.toIso8601String(),
    };
