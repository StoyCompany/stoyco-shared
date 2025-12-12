import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/jsonapi/json_api_helpers.dart';

/// Parses a JSON:API list response into a [PageResult<T>].
///
/// - [json] must be the decoded response body (normally `response.data`).
/// - [fromAttributes] maps the `attributes` map to an instance of `T`.
PageResult<T> parseJsonApiPageResult<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> attrs) fromAttributes, {
  int? defaultPage,
  int? defaultLimit,
}) {
  final doc = JsonApiDocument<T>.fromJsonList(json, fromAttributes);

  final items = doc.data.map((r) => r.attributes).toList();

  final pagination = doc.meta?['pagination'] as Map<String, dynamic>?;

  return PageResult<T>(
    pageNumber: pagination != null ? (pagination['page'] as int?) : defaultPage,
    pageSize: pagination != null ? (pagination['limit'] as int?) : defaultLimit,
    totalItems: pagination != null ? (pagination['total'] as int?) : null,
    totalPages: pagination != null ? (pagination['pages'] as int?) : null,
    items: items,
  );
}
