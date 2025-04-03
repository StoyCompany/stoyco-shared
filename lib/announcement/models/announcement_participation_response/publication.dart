import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publication.g.dart';

@JsonSerializable()
class Publication {

  const Publication({
    this.url,
    this.likes,
    this.shares,
    this.views,
    this.reviewStatus,
    this.publicationDate,
  });

  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);
  final String? url;
  final int? likes;
  final int? shares;
  final int? views;
  @JsonKey(name: 'review_status')
  final String? reviewStatus;
  @JsonKey(name: 'publication_date')
  final DateTime? publicationDate;

  @override
  String toString() =>
      'Publication(url: $url, likes: $likes, shares: $shares, views: $views, reviewStatus: $reviewStatus, publicationDate: $publicationDate)';

  Map<String, dynamic> toJson() => _$PublicationToJson(this);

  Publication copyWith({
    String? url,
    int? likes,
    int? shares,
    int? views,
    String? reviewStatus,
    DateTime? publicationDate,
  }) =>
      Publication(
        url: url ?? this.url,
        likes: likes ?? this.likes,
        shares: shares ?? this.shares,
        views: views ?? this.views,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        publicationDate: publicationDate ?? this.publicationDate,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Publication) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      url.hashCode ^
      likes.hashCode ^
      shares.hashCode ^
      views.hashCode ^
      reviewStatus.hashCode ^
      publicationDate.hashCode;
}
