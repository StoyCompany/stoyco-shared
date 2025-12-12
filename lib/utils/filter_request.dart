class FilterRequest {
  const FilterRequest({
    this.search,
    this.state,
    this.sortBy,
    this.direction,
    this.page,
    this.pageSize,
    this.communityOwnerId,
  });

  /// Text to search in title and short_description fields
  /// Case-sensitive
  /// Optional
  final String? search;

  /// Announcement state
  /// Possible values: 'published', 'closed', 'draft'
  /// Default: 'published'
  final String? state;

  /// Field for sorting announcements
  /// Default: 'published_date'
  final String? sortBy;

  /// Sort direction
  /// 1: ascending, -1: descending
  /// Default: 1 (ascending)
  final int? direction;

  /// Page number to retrieve
  /// Default: 1
  final int? page;

  /// Number of announcements per page
  /// Default: 10
  /// Min: 1, Max: 100
  final int? pageSize;

  final String? communityOwnerId;
}

class FilterRequestHelper {
  /// Converts a FilterRequest object to a URL query string
  /// @param filter The filter object to convert
  /// @returns A query string representation of the filter (without the leading '?')
  static String toQueryString(FilterRequest filter) {
    final params = <String, String>{};

    if (filter.search != null) {
      params['search'] = filter.search!;
    }

    if (filter.state != null) {
      params['state'] = filter.state!;
    }

    if (filter.sortBy != null) {
      params['sort_by'] = filter.sortBy!;
    }

    if (filter.direction != null) {
      params['direction'] = filter.direction.toString();
    }

    if (filter.page != null) {
      params['page'] = filter.page.toString();
    }

    if (filter.pageSize != null) {
      params['page_size'] = filter.pageSize.toString();
    }

    return Uri(queryParameters: params).query;
  }

  static Map<String, dynamic> toQueryMap(FilterRequest filter) {
    final params = <String, dynamic>{};

    if (filter.search != null) {
      params['search'] = filter.search!;
    }

    if (filter.state != null) {
      params['state'] = filter.state!;
    }

    if (filter.sortBy != null) {
      params['sort_by'] = filter.sortBy!;
    }

    if (filter.direction != null) {
      params['direction'] = filter.direction;
    }

    if (filter.page != null) {
      params['page'] = filter.page;
    }

    if (filter.pageSize != null) {
      params['page_size'] = filter.pageSize;
    }

    if (filter.communityOwnerId != null) {
      params['community_owner_id'] = filter.communityOwnerId!;
    }

    return params;
  }
}
