/// Represents the different environments the application can run in.
enum StoycoEnvironment {
  /// Development environment.
  development,

  /// Production environment.
  production,

  /// Testing environment.
  testing,
}

/// Extension on `StoycoEnvironment` to provide the base URL for each environment
extension StoycoEnvironmentExtension on StoycoEnvironment {
  /// Gets the base URL for the current environment
  String baseUrl({String version = 'v1'}) {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://dev.api.stoyco.io/api/stoyco/$version/';
      case StoycoEnvironment.production:
        return 'https://api.stoyco.io/api/stoyco/$version/';
      case StoycoEnvironment.testing:
        return 'https://qa.api.stoyco.io/api/stoyco/$version/';
    }
  }

  String videoPlayerUrl({String version = 'v1'}) {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://yebse2h4e4obpsy25hn5naclaq0qkbos.lambda-url.us-east-1.on.aws';
      case StoycoEnvironment.production:
        return 'https://yebse2h4e4obpsy25hn5naclaq0qkbos.lambda-url.us-east-1.on.aws';
      case StoycoEnvironment.testing:
        return 'https://yebse2h4e4obpsy25hn5naclaq0qkbos.lambda-url.us-east-1.on.aws';
    }
  }

  String get dataS3Url {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.production:
        return 'https://stoyco-medias-prod.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.testing:
        return 'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json';
    }
  }

  String get dataCatalogUrl {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://5ug8wcd6a1.execute-api.us-east-1.amazonaws.com/prod/v1/';
      case StoycoEnvironment.production:
        return 'https://5ug8wcd6a1.execute-api.us-east-1.amazonaws.com/prod/v1/';
      case StoycoEnvironment.testing:
        return 'https://5ug8wcd6a1.execute-api.us-east-1.amazonaws.com/prod/v1/';
    }
  }

  String get videoBaseUrl {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://videos.app.stoyco.io/';
      case StoycoEnvironment.production:
        return 'https://prod.videos.app.stoyco.io/';
      case StoycoEnvironment.testing:
        return 'https://videos.app.stoyco.io/';
    }
  }

  String get urlAnnouncement {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://g0dxqqaj1g.execute-api.us-east-1.amazonaws.com/dev/api/';
      case StoycoEnvironment.production:
        return 'https://x0dnk78u0l.execute-api.us-east-1.amazonaws.com/prod/api/';
      case StoycoEnvironment.testing:
        return 'https://g0dxqqaj1g.execute-api.us-east-1.amazonaws.com/qa/api/';
    }
  }

  String get urlTikTok {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://g0dxqqaj1g.execute-api.us-east-1.amazonaws.com/qa/api/tiktok/user';
      case StoycoEnvironment.production:
        return 'https://x0dnk78u0l.execute-api.us-east-1.amazonaws.com/prod/api/tiktok/user';
      case StoycoEnvironment.testing:
        return 'https://g0dxqqaj1g.execute-api.us-east-1.amazonaws.com/qa/api/tiktok/user';
    }
  }

  /// Base URL for the Activity service per environment.
  ///
  /// QA (testing) uses: https://17lqazupjd.execute-api.us-east-1.amazonaws.com/qa
  String get urlActivity {
    switch (this) {
      case StoycoEnvironment.development:
        // Fallback/dev URL (adjust if a different dev URL is provided)
        return 'https://17lqazupjd.execute-api.us-east-1.amazonaws.com/dev';
      case StoycoEnvironment.production:
        // Fallback/prod URL (adjust if a different prod URL is provided)
        return 'https://17lqazupjd.execute-api.us-east-1.amazonaws.com/prod';
      case StoycoEnvironment.testing:
        return 'https://17lqazupjd.execute-api.us-east-1.amazonaws.com/qa';
    }
  }

  /// Base URL for the Partner service (market segments, partner community).
  String partnerServiceBaseUrl({String version = 'v2'}) {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://zc1kknd34g.execute-api.us-east-1.amazonaws.com/dev/api/stoyco/$version/';
      case StoycoEnvironment.production:
        return 'https://zc1kknd34g.execute-api.us-east-1.amazonaws.com/Prod/api/stoyco/$version/';
      case StoycoEnvironment.testing:
        return 'https://zc1kknd34g.execute-api.us-east-1.amazonaws.com/QA/api/stoyco/$version/';
    }
  }
}
