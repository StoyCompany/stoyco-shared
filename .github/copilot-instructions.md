## Quick goal

Help contributors and automated coding agents be productive in the `stoyco_shared` Flutter/Dart package: describe the architecture, common patterns, build / codegen / test commands, and important integration points.

## Quick setup (commands)

- Install packages: `flutter pub get`
- Generate code (JSON models & flutter_gen):
  - `flutter pub run build_runner build --delete-conflicting-outputs`
  - If using flutter_gen: `flutter pub run build_runner build`
- Run tests: `flutter test` (tests live under `test/`)

## High-level architecture

- This is a shared Flutter/Dart package (see `pubspec.yaml`) that exposes reusable UI, data and service layers from `lib/` via `lib/stoyco_shared.dart`.
- The project follows a consistent DataSource -> Repository -> Service pattern:
  - DataSource: low-level HTTP/API clients that use `dio` and the `StoycoEnvironment` URLs (files end with `_data_source.dart`, e.g. `lib/news/news_data_source.dart`).
  - Repository: maps data source responses to domain models and wraps errors into `Failure` objects (files end with `_repository.dart`, e.g. `lib/announcement/announcement_repository.dart`).
  - Service: singleton or factory façade used by apps, returning Either<Failure, T> and providing higher-level helpers (files end with `_service.dart`, e.g. `lib/news/news_service.dart`, `lib/announcement/announcement_service.dart`).

## Important conventions and patterns (project-specific)

- API base URLs use the `StoycoEnvironment` enum and extension in `lib/envs/envs.dart`. Always call `environment.baseUrl()` (optionally with `version`) when constructing endpoints.
- HTTP implementations use `dio` with `CancelToken` for cancellable requests (see `NewsDataSource.getPaged`).
- Return types: most public methods return `Either<Failure, T>` (from `either_dart`) or `Future<Either<Failure, T>>`. Follow this pattern when adding new endpoints.
- Pagination: use `PageResult<T>` model located under `lib/models/page_result`.
- JSON (de)serialization: models use `json_serializable` + generated files; run build_runner after model changes.
- Singletons: many services are singletons (factory constructors). Some services include `resetInstance()` helpers for tests (e.g. `AnnouncementService.resetInstance()`). When writing tests, prefer resetting singletons between cases.
- Logging: use the project logger `StoyCoLogger` in `lib/utils/logger.dart` for consistent error messages.

## Documentation (required)

- All public APIs, classes, methods and complex behaviors must be documented using Dartdoc (`///` comments) in English. This repository uses English for all public-facing documentation so generated docs and IDE tooltips are consistent for consumers.
- Keep Dartdoc concise: one-line summary, parameter descriptions (`@param` not required; use normal text), return description, and a short example when helpful.
- Example:
  ````dart
  /// Fetches a paginated list of news.
  ///
  /// Returns an [Either] with [Failure] on the left or [PageResult<NewModel>] on the right.
  ///
  /// Example:
  /// ```dart
  /// final result = await NewsService(environment: env).getNewsPaginated(1, 10);
  /// ```
  Future<Either<Failure, PageResult<NewModel>>> getNewsPaginated(int pageNumber, int pageSize) =>
      _newsRepository!.getNewsPaginated(pageNumber, pageSize);
  ````

## Code examples (copy/paste patterns)

- New DataSource method (use environment + dio):
  - See `lib/news/news_data_source.dart` — endpoint built as `${environment.baseUrl()}news/paged` and uses `CancelToken`.
- Service singleton factory:
  - See `lib/news/news_service.dart` — factory creates or returns `_instance`, initializes DataSource + Repository.
- Remote config usage:
  - See `lib/announcement/announcement_service.dart` where `FirebaseRemoteConfig` values are read (e.g. `remoteConfig.getBool('enable_announcement_v2')`, `remoteConfig.getValue('tiktok_config').asString()`).

## Integrations & external dependencies

- Firebase Remote Config: used in announcements to drive runtime flags and JSON config (`lib/announcement/announcement_service.dart`).
- MoEngage, Firebase Messaging, and other platform SDKs are referenced in `pubspec.yaml` (validate platform setup in host apps).
- TikTok integration uses specific external endpoints defined in `StoycoEnvironment` (`urlTikTok`) and helper DataSource/Repository/Service files under `lib/tiktok/`.
- Native assets & ffmpeg packages live under `external_packages/` — be cautious when updating versions; maintainers may keep local copies here.

## Tests & codegen notes

- Run `flutter test` for unit/widget tests in `test/`.
- After changing model annotations or generated code: run build_runner with `--delete-conflicting-outputs`.
- Keep `lib/gen/assets.gen.dart` in sync by regenerating `flutter_gen` outputs when asset lists change.

## Common pitfalls and reminders for code authors/agents

- Preserve public API exports in `lib/stoyco_shared.dart` when adding new top-level modules.
- Follow the DataSource -> Repository -> Service layering; avoid putting business logic in DataSource.
- Wrap raw exceptions into the project's `Failure` objects inside repositories (search for `Failure` under `lib/errors`).
- When reading remote config keys, prefer safe defaults and wrap parsing errors with logger calls (see `getParticipationFormConfig`).
- Respect singleton initialization: some services will reuse existing instances if environment/remoteConfig are identical — for tests you may need to call reset helpers.

## Where to look first (key files)

- `pubspec.yaml` — deps and codegen tools
- `lib/stoyco_shared.dart` — package public exports
- `lib/envs/envs.dart` — base URLs and environment helpers
- `lib/*/*_data_source.dart`, `lib/*/*_repository.dart`, `lib/*/*_service.dart` — canonical pattern files
- `lib/announcement/announcement_service.dart` — example of Remote Config + repository usage
- `lib/news/news_data_source.dart` and `lib/news/news_service.dart` — simple example flow

If anything above is unclear or you want more examples (tests, adding a new API, or a PR template), tell me which area to expand and I'll iterate.
