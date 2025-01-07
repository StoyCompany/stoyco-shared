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
  String get baseUrl {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://dev.api.stoyco.io/api/stoyco/v1/';
      case StoycoEnvironment.production:
        return 'https://api.stoyco.io/api/stoyco/v1/';
      case StoycoEnvironment.testing:
        return 'https://qa.api.stoyco.io/api/stoyco/v1/';
    }
  }

  String get dataS3Url {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.production:
        return 'https://stoyco-medias-prod.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.testing:
        return 'https://stoyco-medias-qa.s3.amazonaws.com/data/coach_mark_data.json';
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
}
