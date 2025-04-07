// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Metrics _$MetricsFromJson(Map<String, dynamic> json) => Metrics(
      totalPublications: (json['total_publications'] as num?)?.toInt(),
      totalLikes: (json['total_likes'] as num?)?.toInt(),
      totalShares: (json['total_shares'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetricsToJson(Metrics instance) => <String, dynamic>{
      'total_publications': instance.totalPublications,
      'total_likes': instance.totalLikes,
      'total_shares': instance.totalShares,
    };
