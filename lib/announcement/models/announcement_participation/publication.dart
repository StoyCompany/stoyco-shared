import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publication.g.dart';

@JsonSerializable()
class Publication {
  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);

  const Publication({this.url, this.publicationDate});
  final String? url;
  @JsonKey(name: 'publication_date')
  final DateTime? publicationDate;

  @override
  String toString() =>
      'Publication(url: $url, publicationDate: $publicationDate)';

  Map<String, dynamic> toJson() => _$PublicationToJson(this);

  Publication copyWith({
    String? url,
    DateTime? publicationDate,
  }) =>
      Publication(
        url: url ?? this.url,
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
  int get hashCode => url.hashCode ^ publicationDate.hashCode;
}
