/// Minimal helpers to represent JSON:API documents and resource objects.
/// These helpers avoid requiring code generation and provide a simple way to
/// parse `data` / `attributes` payloads following jsonapi.org conventions.
library;

class ResourceObject<T> {
  factory ResourceObject.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromAttributes,
  ) =>
      ResourceObject<T>(
        type: json['type'] as String,
        id: json['id'] as String,
        attributes: fromAttributes(json['attributes'] as Map<String, dynamic>),
      );
  ResourceObject({
    required this.type,
    required this.id,
    required this.attributes,
  });

  final String type;
  final String id;
  final T attributes;

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T) attributesToJson,
  ) =>
      {
        'type': type,
        'id': id,
        'attributes': attributesToJson(attributes),
      };
}

class JsonApiDocument<T> {
  factory JsonApiDocument.fromJsonList(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromAttributes,
  ) {
    final rawData = json['data'] as List<dynamic>? ?? <dynamic>[];
    final list = rawData
        .map(
          (e) => ResourceObject<T>.fromJson(
            e as Map<String, dynamic>,
            fromAttributes,
          ),
        )
        .toList();
    return JsonApiDocument<T>(
      data: list,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
  JsonApiDocument({required this.data, this.meta});

  final List<ResourceObject<T>> data;
  final Map<String, dynamic>? meta;

  Map<String, dynamic> toJsonList(
    Map<String, dynamic> Function(T) attributesToJson,
  ) =>
      {
        'data': data.map((r) => r.toJson(attributesToJson)).toList(),
        if (meta != null) 'meta': meta,
      };
}
