## 21.5.15

**fix(InteractiveContent):** update Desing events

## 21.5.14

**fix(InteractiveContent):** update Desing events

## 21.5.13

**fix(InteractiveContent):** update Desing events

## 21.5.12

**feat(partner):** enable force refresh for cached partner data retrieval

## 21.5.10

**feat(video):** integrate active subscription validation in video player repository and service

## 21.5.9

**fix(Events):** implements correct type for free events

## 21.5.6

**feat(Logic):** implements auxiliar methods for Interactions

## 21.5.5

**feat(cache):** implement global cache management and invalidation features

- Added GlobalCacheManager to track all cache managers and provide global operations.
- Introduced CacheUtils for easy access to cache operations from any application layer.
- Enhanced RepositoryCacheMixin with static methods for global cache invalidation.
- Updated InMemoryCacheManager and PersistentCacheManager to register with GlobalCacheManager upon creation.
- Added tests for CacheUtils and GlobalCacheManager to ensure functionality and reliability.
- Updated README.md to document new features and usage examples for global cache management.
  **feat:** add cache invalidation methods to PartnerService and update version in pubspec.yaml

## 21.5.0

**feat(feed):** Refactor FeedContentItem and NewsRepository for improved access validation

- Refactored FeedContentItem model to enhance access control logic and support for subscription-based access.
- Updated NewsRepository to validate access for feed items before mapping to FeedContentAdapter, ensuring correct access flags and types.
- Improved consistency in access validation across paginated feed and event endpoints.

**refactor:** FeedContentItem and VideoWithMetadata models for improved access control

- Refactored FeedContentItem and VideoWithMetadata models to centralize and clarify access control logic.
- Enhanced model structure for better maintainability and future feature expansion.

**feat(feed):** Add AccessContent class and refactor FeedContentItem model

- Introduced AccessContent class to encapsulate access-related properties for feed items.
- Refactored FeedContentItem to use AccessContent, improving code clarity and separation of concerns.

**merge:** Synced with latest changes from 'test' branch

- Merged updates from 'test' branch to keep QA branch up to date.

## 21.4.3

**-fix(dependencies):** update package route

## 21.4.0

feat: Add PartnerContentAvailabilityResponse model and related serialization logic

- Implemented PartnerContentAvailabilityResponse and PartnerContentAvailabilityData classes for handling content availability responses from the API.
- Added JSON serialization and deserialization methods using json_annotation.
- Included unit tests for cache management in InMemoryCacheManager and PersistentCacheManager.
- Developed tests for the NewsRepository to ensure correct caching behavior and error handling.
- Created mock classes for testing with Mockito to simulate data source interactions.

## 21.3.11

**feat(cache):** enhance video cache management with partner following updates and tests

## 21.3.10

**feat(cache):** add generic caching system for repositories

- Implemented generic `CacheEntry<T>` model with TTL and expiration tracking
- Created abstract `CacheManager` interface for flexible cache implementations
- Added `InMemoryCacheManager` singleton for in-memory caching
- Introduced `RepositoryCacheMixin` to easily add caching to any repository
- Features include:
  - Automatic cache expiration based on TTL
  - Force refresh capability
  - Pattern-based cache invalidation
  - Support for `Either<Failure, T>` return types
  - Full test coverage with unit tests
- Comprehensive documentation and usage examples included

## 21.3.9

**feat(video):** add examples for persistent caching and prefetching

- Implemented `persistent_cache_example.dart` demonstrating initialization, usage, and cache management in a video feed application.
- Created `prefetching_example.dart` to showcase automatic prefetching of video pages for seamless pagination.
- Added tests for video cache interactions in `video_cache_interaction_test.dart` to ensure proper updates and removals of cached videos.
- Developed `video_cache_manager_test.dart` to validate cache manager functionalities including storage, retrieval, and expiration of cached videos.
- Introduced `video_player_service_cache_test.dart` to verify caching behavior in the video player service, ensuring efficient data retrieval and cache management.
- A component update Interactive Content

## 21.3.8

**-fix(dependencies):** update share_plus to version 12.0.1

## 21.3.7

**-feat(announcements):** update Models Announcements

## 21.3.6

### Added

- **feat (LoopVideoPlayer widget):** A component has been added to view videos in an infinite loop.

- **feat (SharedLike widget):** A component has been added to display sharing and liking.
- **feat (SocialButton widget):** A component is added to render the icon and text for like and share.

## 21.3.6

### Added

- **feat (VideoExclusiveBlur widget):** Introduced a new molecule widget for exclusive video content overlays, including blur, lock/tag indicator, and customizable UI for premium/locked content.
- **fix (NewModel fields):** Added `communityOwnerId`, `isSubscriberOnly`, and `hasAccess` fields to `NewModel`, with updated JSON serialization.
- **fix (AnnouncementModel fields):** Added `communityOwnerId`, `isSubscriberOnly`, and `hasAccess` fields to `AnnouncementModel`.

## 21.3.5

**-feat(announcements):** update design Fo rAnnouncements

## 21.3.4

**-fix(moengage):** update import statement and clean up comments in MoEngageService

## 21.3.3

- **feat(video):** add partnerId parameter to getVideosWithFilter and getFeaturedVideos methods for filtering videos by specific partner

## 21.3.1

- **feat(news):** Updated news item models and services param requirements
- **fix(moEngage)** Updated moengage service param requirements, making the pushToken optional in order to use it in web

## 21.3.0

- **feat(notification):** Add InteractiveContent Data for announcements,news,feedtype3

## 21.2.6

- **fix(env):** update URL endpoints for announcement service in StoycoEnvironmentExtension

## 21.2.5

- **fix(video):** update query parameters to use 'pageSize' and 'pageNumber' in getVideosWithFilter

## 21.2.4

- **fix(video):** rename 'page' to 'pageNumber' in getVideosWithFilter query parameters

## 21.2.3

- **feat(video):** add description field to video metadata in VideoPlayerRepositoryV2

## 21.2.2

- **feat(video):** add description field to video metadata

## 21.2.1

- **feat(filter):** add communityOwnerId to query parameters in FilterRequestHelper

## 21.2.0

- **feat(video):** enhance video fetching with userId and pagination support

## 21.1.0

- **feat(video):** Add StreamingData model for comprehensive video metadata handling
- **feat(video):** Enhance video player service with viewVideo and getVideosWithFilter methods
- **feat(video):** Add userId parameter to likeVideo and dislikeVideo methods for better user tracking
- **feat(video):** Improve VideoPlayerService reset method to clear datasource token
- **feat(video):** Update VideoWithMetadata model to include StreamingData

## 21.0.0

**feat(notification):** Adding push notificacion with moengage sdk

## 20.0.2

- **feat(announcement):** Adding a community owner filter to the announcement service using the ID and adjusting the models

- **feat(news):** Adding a community owner filter to the news service using the ID and adjusting the models

## 20.0.1

- **feat(notification):** add isStoyCoinsNotification getter to identify StoyCoins-related notifications

## 20.0.0

- **feat(activity):** implement ActivityRepository and ActivityService for notifications and messages

- Added ActivityRepository to handle data operations for notifications and messages.
- Implemented ActivityService to manage business logic and token handling for activity-related API calls.
- Created models for ActivitySummary, Message, NotificationStats, MessageStats, and UserUnifiedStats with JSON serialization.
- Introduced JSON:API helpers for parsing API responses.
- Updated environment configurations to include Activity service URLs. (See <attachments> above for file contents. You may not need to search or read the file again.)

## 19.0.1

- **fix:** Correct MoEngage SDK initialization to ensure proper setup and functionality
-

## 19.0.0

- **feat:** Add MoEngage SDK integration for advanced user engagement and analytics

## 18.0.3

- **fix:** Update hasActiveAnnouncements method to accept platform parameter for dynamic configuration

## 17.7.0

- **feat:** Add TikTok authentication check and enhance ExpandableButton layout for better responsiveness

## 16.6.18

- **feat:** Refactor code structure for improved readability and maintainability

## 16.6.17

- **feat:** Update layout in AnnouncementLeaderShipDialog for better responsiveness

## 16.6.14

- **feat:** Add carousel functionality to VideoSlider and implement getCountOfVideos

## 16.5.0

- **feat:** Add paddingScrollBar property to AnnouncementPrizePanel and enhance documentation for AnnouncementDataSource and AnnouncementRepository methods

## 16.4.4

- **feat:** Enhance AnnouncementParticipationFormDialog and CoverImageWithFade with improved validation, loading states, and customizable styles

## 16.4.0

- **feat:** Add announcement participation models and data source methods

## 16.2.0

- **feat:** Implement getAnnouncementById method in AnnouncementDataSource and update repository and service layers

## 16.1.0

- **feat:** Add AnnouncementDataSource for fetching announcements; update models and generated files

## 16.0.1

- **feat:** feat: Add AnnouncementLeaderboardItem model and new SVG icons; update pubspec.yaml dependencies

## 16.0.0

- **feat:** Add AnnouncementModel with JSON serialization and megaphone icon asset

## 15.1.0

- **feat:** Add new parameters for responsive behavior in a single method call

## 15.0.0

- **feat:** Add environment-specific video base URL handling in ParallaxVideoCard

## 14.0.4

- **feat:** Refactor video thumbnail handling to use a Map for improved indexing and loading state management

## 14.0.3

- **feat:** Sort videos by order in VideoSlider for improved playback sequence

## 14.0.2

- **feat:** Add showErrors parameter to StoycoDatePickerModal for error display control

## 14.0.1

- **feat:** Add optional width and height parameters to VideoSlider for customizable dimensions

## 14.0.0

- **feat:** Add video player support with caching and user interaction models

## 13.7.0

- **feat:** Update SVG icons for improved design and add reaction_arrow_down icon

## 13.6.6

- **feat:** Allow customizable shadow color in TutorialCoachMark

## 13.6.5

- **feat:** Enhance TutorialCoachMark with customizable shadow opacity and image filter options

## 13.6.4

- **feat:** Update material_person.svg icon color to black for improved visibility

## 13.6.3

- **feat:** Enhance score handling in VideoInteractionsWidgetV2

## 13.6.1

- **feat:** Add ShareVideoWidgetV2 for sharing videos with customizable options

## 13.6.0

- **feat:** feat: functionality to fetch videos with metadata

## 13.5.3

- **feat:** Remove background color from SkeletonCard for improved design consistency

## 13.5.2

- **feat:** Update the notification filtering method to use the notification model

## 13.5.1

- **feat:** Add method to filter allowed notifications on the web

## 13.5.0

-**feat:** Refactor notification model and types structure for better organization

## 13.4.13

- **feat:** Improve exception handling in CoachMarkService

## 13.4.12

- **feat:** Fix URL construction in NewsDataSource and CoachMarkDataSource

## 13.4.10

- **feat:** Add support for video sharing on web in VideoPlayerService

## 13.4.8

- **feat:** Simplify total score display in VideoInteractionsWidget and VideoInteractionsWidgetWeb

## 13.4.6

- **feat:** Replace InkWell with GestureDetector in video widgets to improve interaction

## 13.4.5

- **feat:** Rename ShareVideoWidget to ShareVideoWidgetWeb and VideoInteractionsWidget to VideoInteractionsWidgetWeb

## 13.4.4

- **feat:** Add Gap for space in interaction widgets and video sharing

## 13.4.3

- **feat:** reset like and dislike states when user reaction type is null in VideoInteractionsWidget

## 13.4.2

- **feat:** reset userToken when setting function to update token in VideoPlayerService

## 13.4.1

- **feat:** rename VideoInteractionsWidget a VideoInteractionsWidgetWeb

## 13.4.0

- **feat:** refactor ShareVideoWidget to separate web sharing functionality into ShareVideoWidgetWeb

## 13.2.1

- **feat:** add support for video sharing on web and mobile devices in ShareVideoWidget

## 13.2.0

- **feat:** improve error handling in CoachMarkService and update version to 13.2.0

## 13.1.0

- **feat:** add ShareVideoWidget for sharing videos with customizable options and loading state

## 13.0.2

- **feat:** update getUserVideoInteractionData to use new URI format for video interactions

## 13.0.1

- **feat:** make functionToUpdateToken nullable and improve token verification logic with error handling

## 13.0.0

- **feat:** add VideoPlayerModel and VideoInteraction models with JSON serialization, and implement VideoPlayerDataSourceV2 for video interactions

## 12.0.19

- **feat:** make modal scrollable and adjust layout with padding in showStoycoModal

## 12.0.18

- **feat:** Add color filter to SVG icon in CompleteProfileWidget.

## 12.0.17

- **feat:** Change icon parameter to accept SVG widget in CompleteProfileWidget.

## 12.0.14

- **feat:** Add isEmpty and isNotEmpty getters to UserLocationInfo model.

## 12.0.12

- **feat:** Remove unused JsonKey annotations in UserLocationInfo model.

## 12.0.11

- **feat:** Wrapped the search icon in an UnconstrainedBox in StoycoDropDownFieldWithModalV2.

## 12.0.10

- **feat:** Added parameter searchIconHeight in StoycoDropDownFieldWithModalV2.

## 12.0.9

- **feat:** Change size of search icon in StoycoDropDownFieldWithModalV2.

## 12.0.7

- **feat:** Change size of search icon in StoycoDropDownFieldWithModalV2.

## 12.0.6

- **feat:** Add margin to search icon in StoycoDropDownFieldWithModalV2.

## 12.0.4

- **feat:** Add width property to search icon in StoycoDropDownFieldWithModalV2.

## 12.0.3

- **fix:** Updated icon paths used in StoycoDropDownFieldWithModalV2.

## 12.0.2

- **feat:** Added locationInfo to UserUpdateDTO.

## 12.0.1

- **feat:** Added optional width property to CompleteProfileWidget.

## 12.0.0

- **feat:** Added CompleteProfileWidget, ModalCompleteProfile, DialogContainer, GradientPainter.

## 11.0.11

- **feat:** Added new search and verification icons to options selection modal.

## 11.0.9

- **feat:** Removed visual separator in options selection modal for cleaner interface.

## 11.0.8

- **feat:** Added width property to StoycoDropDownFieldWithModalV2 for custom sizing.
- **feat:** improve dropdown selection handling in modal for better user experience

## 11.0.7

- **refactor:** Removed unnecessary type adapter dependency.

## 11.0.6

- **feat:** Added locationInfo to UserDTO model for managing user location data.
- **refactor:** Removed unnecessary Hive dependencies.

## 11.0.5

- **feat:** Added UserLocationInfo model for managing user location data.

## 11.0.4

- **fix:** Improvements in geo entity and dropdown field.

## 11.0.3

- **fix:** Design corrections to prevent overflow issues in modals.

## 11.0.2

- **fix:** Removed a slash that caused an error when calling the catalog.

## 11.0.1

- **fix:** Corrected the base URL for the catalog DS.

## 11.0.0

- **feat:** Created geo service to obtain the catalog of countries and cities from Stoyco.
- **feat:** Created drop down field with modal v2 to include a search feature.

## 10.0.0

- **feat:** Update map dependencies and launch URLs instead of using maps_launcher in the web widget

## 9.0.9

- **feat:** update date parsing in NewsCard widget to convert scheduledPublishDate and createdAt to local time

## 9.0.8

- **feat:** createdAt field to NewModel and update related logic in NewsCard widget

## 9.0.7

- **feat:** update NewsCard widget to use main image instead of image list for improved display

## 9.0.6

- **feat:** remove date range icon from NewsCard widget to streamline design

- **feat:** news card image handling improve image loading logic to display a placeholder when no images are available

## 9.0.4

- **feat:** Add calendar icon and update close icon formatting; include SvgPicture in NewsCard

### 9.0.3

- **refactor:** Updated markAsViewed method to interpret the response based on the status code instead of response data for improved logic handling.

### 9.0.2

- **chore:** Ran build_runner build to generate necessary files.

### 9.0.1

- **docs:** Documented NewsCard, NewsService, and ScreenSize.

### 9.0.0

- **feat:** Created the news sub-package to fetch Stoyco news and mark them as viewed.
- **feat:** Added the StoycoScreenSize class.
- **refactor:** Refactored the Colors class.

## 8.0.26

- **feat:** Added new notification type onboardingCompleted.

## 8.0.25

- **fix:** Corrected the setState usage in CoachMarkContainerWidget.

## 8.0.24

- **refactor:** Refactor `CoachMarkContainerWidget` to `StatefulWidget`

- **feat:** Add global key to `CoachMarkContainerWidget`

## 8.0.23

- **refactor:** Refactor `CoachMarkContainerWidget` to `StatefulWidget`

## 8.0.22

- **feat:** can show menu info expanded at `Colapse` widget.

## 8.0.21

- **refactor:** Refactor user icon in `StoycoProfileEditWidget`

## 8.0.20

- **refactor:** Refactor `reset` in `CoachMarkService`, reset `functionToUpdateToken` and `UserId`

## 8.0.19

- **refactor:** Refactor `currentStep` validation in `CoachMark`

## 8.0.18

- **refactor:** Refactor initialization of `_isCoachMarkController` in `CoachMarkService`

## 8.0.17

- **feat:** Add `setFunctionToUpdateToken` to `coachMarkService`

## 8.0.16

- **change:** Icon paths updated

## 8.0.15

- **change:** CoachMarkContainerWidget now uses custom icons instead of Material icons

## 8.0.14

- **feat:** Add `FunctionToUpdateTokenNotSetException` exception

- **change:** `showSelectOptionModal` function now returns `Future<String?>`

## 8.0.13

- **feat:** Add `verifyToken` to `getCouchMarksContent`

### 8.0.12

- feat: Refactoring input data reset method into CoachMarkDataSource and StoycoDatePickerModal

## 8.0.11

- feat: Refactoring platform handling in LaunchLocationWidget

## 8.0.10

- feat: Improve exception handling in LaunchLocationWidget

## 8.0.9

- **feat:** Add `dataS3Url` getter to StoycoEnvironmentExtension

  A new getter `dataS3Url` has been added to `StoycoEnvironmentExtension`. This getter provides the correct URL for the JSON file based on the current environment (`development`, `production`, or `testing`). This enhancement improves the flexibility and maintainability of the code by centralizing the logic for determining the appropriate data source URL based on the environment.

## 8.0.8

- **refactor:** Refactor onboarding data reset method in CoachMarkDataSource

  The method responsible for resetting onboarding data in CoachMarkDataSource has been refactored to improve code clarity, efficiency, or maintainability. This refactor may involve simplifying the logic, optimizing performance, or enhancing code readability.

## 8.0.7

- **refactor:** Refactor platform handling in LaunchLocationWidget

  The `kIsWeb` parameter has been removed from LaunchLocationWidget, and a new widget called LaunchLocationWebWidget has been created to handle the specific styling and behavior for the web platform. This further improves code organization and separation of concerns, making it easier to maintain and update platform-specific implementations.

## 8.0.6

- **refactor:** Refactor platform handling in LaunchLocationWidget

  The platform handling logic in LaunchLocationWidget has been refactored to improve code organization and maintainability. This refactor aims to make the code more readable and easier to understand, especially when dealing with platform-specific styling or behavior.

## 8.0.5

- **feat:** Update "Get Directions" button style in LaunchLocationWidget

  The style of the "Get Directions" button in LaunchLocationWidget has been updated to handle different styles depending on the platform. A condition was added to apply specific styles when running on the web. In addition, the padding, background color, text color, and minimum button size styles were adjusted.

## 8.0.4

- **fix:** Replace `WidgetStateProperty.all` with `WidgetStatePropertyAll` to avoid error reports in Flutter versions 3.24.1 and above.

## 8.0.3

- test: Add unit tests for the `coach_mark` package

## 8.0.2

- docs: Document the coach_mark package

## 8.0.1

- chore: Run dart format on the project and dart fix on the project

## 8.0.0

- feat: Add new dependencies and update existing ones

  - Added glassmorphism, gradient_borders, dio, and either_dart dependencies
  - Updated intl and url_launcher dependencies to latest versions
  - Updated firebase_core_platform_interface and maps_launcher dependencies

  ### Refactor the Failure class

  - Moved the Failure class to a separate file
  - Added the Equatable mixin to the Failure class

  ### Add CoachMark module

  - Created the CoachMark module with various components and error handling classes
  - Added CoachMark, CoachMarksContent, CoachMarkData, and Onboarding classes
  - Generated code for JSON serialization and deserialization

  ### Add SVG icon file

  - Added the check_icon_coach_mark.svg file to the assets/icons directory

  ### Update errors module

  - Added exports for various error handling classes in the errors module

  ### Update pubspec.yaml

  - Added tutorial_coach_mark dependency

  ### Update errors.dart

  - Added exports for various error handling classes in the errors.dart file

  ### Update coach_mark.dart

  - Added exports for various coach mark related classes in the coach_mark.dart file

  ### Update coach_marks_content.dart

  - Added exports for various coach marks content related classes in the coach_marks_content.dart file

  ### Update exception.dart

  - Added various exception classes for error handling in the exception.dart file

  ### Update coach_marks_content.g.dart

  - Generated code for JSON serialization and deserialization in the coach_marks_content.g.dart file

  ### Update coach_mark.g.dart

  - Generated code for JSON serialization and deserialization in the coach_mark.g.dart file

  ### Update onboarding.dart

  - Added the Onboarding class for managing onboarding data
  - Added the OnboardingType enum for different types of onboarding

  ### Refactor error handling in error.dart

  - Refactored the ErrorFailure and HiveFailure classes for error handling

  ### Refactor error handling in failure.dart

  - Refactored the ErrorFailure and HiveFailure classes for error handling

## 7.1.4

- feat: Update text field with check to remove null check

## 7.1.3

- feat: Add `PinCode` field to form fields

## 7.1.2

- feat: Update pin_code_fields package to version 7.1.2

## 7.0.1

- feat: Update StoycoCountryPrefixIcon to improve UI and add language support

### 6.2.2

- feat: Refactor PhoneNumber class to improve code readability and maintainability

## 6.2.1

- feat: Add BorderGradientStoyco widget documentation for custom border gradient effect

## 6.2.0

- feat: Introduce `BorderGradientStoyco` and `StoycoOutlinedButton` widgets.

  - **`BorderGradientStoyco`**: A new widget that allows creating a custom border with a gradient around a child `Widget`. It uses a `CustomPainter` to draw the border, providing an attractive and customizable visual effect.

    - Adds support for configuring the border thickness (`strokeWidth`), corner radius (`radius`), and a gradient (`gradient`) to style the border.

  - **`StoycoOutlinedButton`**: A stylized button that includes a gradient border and custom shadows, designed to stand out in the user interface. This button is highly configurable, allowing customization of its size, text style, and click behavior.
    - Includes support for adjusting the button's width (`width`), height (`height`), and text style (`style`).
    - Uses `BorderGradientStoyco` to achieve a gradient border effect around the button, offering a modern and consistent aesthetic across the interface.

This change adds new customization and design options to your library, enabling developers to create more visually appealing and dynamic user interfaces.

## 6.1.4

- feat: Update StoycoContainerModal to include showTitle parameter and fix layout issue

## 6.1.3

- feat: Update StoycoContainerModal to include showTitle parameter

## 6.1.2

- feat: Add showTitle parameter to StoycoContainerModal

## 6.1.0

- chore: Update showModalBottomSheet to include useRootNavigator parameter

## 6.0.2

- chore: Update PhoneNumber structure for user data field

## 6.0.1

- chore: Update CampaignAppDataDto to use Map<String, String> for data field

## 6.0.0

- feat: Add notification model to shared library

## 5.2.1

- chore: Update intl and url_launcher dependencies to latest versions

## 5.2.0

- chore: Update intl and url_launcher dependencies to latest versions

## 5.1.0

- chore: Update reactive_forms dependency to version 17.0.1 in pubspec.yaml

## 5.0.5

- feat: Add textStyle property to LaunchLocationWidget

## 5.0.4

- feat: Add padding property to LaunchLocationWidget

## 5.0.3

- chore: Update pubspec.yaml version to 5.0.3 and add SVG support to LaunchLocationWidget

## 5.0.2

- fix enabled property type in WidgetButton

## 5.0.1

- Added `StoycoTextButton` and `StoycoExpandableButton` to `utils.dart`: This update introduces two new button widgets, `StoycoTextButton` and `StoycoExpandableButton`, to the `utils.dart` file. These widgets are designed to provide developers with additional options for creating interactive elements in their applications, enhancing the user experience and promoting a more engaging interface.
  - Key Features:
    - **StoycoTextButton**: A simple text button widget that allows developers to create clickable text elements with customizable text styles and callbacks.
    - **StoycoExpandableButton**: An expandable button widget that provides a collapsible content area for displaying additional information or options. It includes customizable header and content sections, as well as expand/collapse animations.
  - Usage Example:
    Demonstrates how to implement the `StoycoTextButton` and `StoycoExpandableButton` widgets in a Flutter application, showcasing their features and customization options.
  - Impact:
    This update expands the library's collection of UI components, offering developers more flexibility and versatility in designing interactive elements for their applications. By providing additional button options, developers can create more engaging and user-friendly interfaces, enhancing the overall user experience.

## 5.0.0

- Remove unnecessary files and update dependencies

## 3.1.1

chore: Update intl dependency to version 0.18.1

## 3.1.0

- chore: Update Flutter plugin dependencies and paths in .flutter-plugins file

## 1.0.3

- Added imports for text buttons and expandable buttons in `utils.dart`: This update enhances the utility file by incorporating additional imports specifically for text buttons and expandable buttons. This inclusion broadens the scope of readily available UI components for developers, facilitating easier access and implementation of these common interactive elements within their applications.

  - Key Enhancements:

    - **Text Buttons**: Now more accessible for implementation, text buttons are essential for simple, text-based user interactions within the UI.
    - **Expandable Buttons**: Catering to more dynamic UI requirements, the addition of expandable buttons allows for a richer, more engaging user experience with collapsible and expandable content.

  - Impact:
    This update streamlines the development process by ensuring that commonly used button types are easily accessible, reducing the need for repetitive code and promoting a more efficient workflow. These components are crucial for creating intuitive and user-friendly interfaces, thereby enhancing the overall user experience in applications built with this library.

## 1.0.2

- Added StoycoEditPhotoWidget: A new widget to further enhance profile management and customization. The StoycoEditPhotoWidget is designed to offer a more advanced and interactive way for users to manage their profile photos, including features such as editing and updating their image directly from the UI.
  - Key Features:
    - Provides a customizable circular container for the user photo, with options for dimensions, border thickness, and background color.
    - Includes an edit button with customizable icon and layout, allowing users to trigger the photo editing process.
    - Offers a flexible `onTapEdit` callback for handling edit button interactions, enabling developers to implement custom photo editing logic.

## 1.0.1

- Updated icon resource files: This release includes updates to the icon resource files, ensuring that the latest icons are available for use within the library. This enhancement improves the visual elements available to developers, offering more options for UI customization.
- Added **UserDTO**: Introduced a Data Transfer Object (DTO) for user data management. The `UserDTO` class is designed to facilitate the transfer and manipulation of user-related data within applications, promoting cleaner code and easier data handling between UI components and backend services.

This update marks a significant enhancement in resource management and data handling capabilities within the library, providing developers with improved tools for building comprehensive and efficient applications.

---

## 0.0.27

- Added **Collapse** widget: Introduces a collapsible menu item feature to the library. This widget is designed to display a menu item with an expandable content section, enhancing navigation and organization within applications. It includes a header with a name and icon, alongside a content area that users can show or hide.
  - Key Features:
    - Provides a structured layout for items that need to show and hide content dynamically.
    - Includes customizable header with name and icon for easy identification.
    - Offers a flexible content area for any widget, facilitating a wide range of use cases.
  - Usage Example:
    Showcases how to implement the `Collapse` widget to create a collapsible menu item, including the setup for name, icon, and the expandable content area.

This update adds a valuable component for developers looking to include collapsible elements within their UI, promoting a cleaner and more organized interface.

---

## 0.0.26

- Introduced **StoycoProfileEditWidget**: A new widget to enhance the user experience in profile editing scenarios. It showcases a profile picture with an editable interface, including a customizable circular container for the image, an edit button, and various styling options. This widget is designed to facilitate intuitive interactions for updating profile photos or personal information, with a focus on flexibility and user engagement.
  - Key Features:
    - Visual customization options for circular container dimensions, border thickness, edit icon size and layout, and background color.
    - Support for displaying a user photo from a URL.
    - An `onTapEdit` callback for handling edit button interactions.
  - Usage Example:
    Demonstrates basic usage including setting dimensions, colors, user photo, and handling the edit event.

This update continues the library's commitment to providing flexible, customizable components for creating engaging and functional user interfaces in Flutter applications.

---

## 0.0.25

- Add StoycoSimplePasswordField

---

## 0.0.24

- Add StoycoValidators

---

## 0.0.23

- Add selectedCountry parameter to StoycoCountryPrefixIcon constructor

---

## 0.0.22

- Add drop down field with modal

---

## 0.0.21

- Remove unnecessary text and divider in date picker modal

---

## 0.0.20

- Refactor date picker modal and modal container

---

## 0.0.19

- Update select.dart
- Add custom_date_picker.dart
- Update drop_down_field.dart

---

## 0.0.18

- Add select widget and update color filter

---

## 0.0.17

- Update main.dart and SVG files, and modify date picker and country icon field

---

## 0.0.16

- Add minHeight and maxHeight properties to ReactiveNewPhoneNumberInput

---

## 0.0.15

- Refactor inputFormatters in StoycoTextFieldWithCheck

---

## 0.0.14

- Add 'gap' package for better spacing in country icon field

---

## 0.0.13

- Add DatePickerView to example and update sufixIcon StoycoDatePicker

---

## 0.0.12

- Add suffix icon to StoyCoTextFormField
- Add asyncValidate to StoycoTextFieldWithCheck

---

## 0.0.11

- Update file paths for icon assets

---

## 0.0.10

- Add AppBar Auth Widget

---

## 0.0.9

- Add 'touched' flag to ReactiveNewPhoneNumberInput

---

## 0.0.8

- Add phone number field and update country icon field

---

## 0.0.7

- Add password and checkbox fields to form library

---

## 0.0.6

- Update file paths for icons

---

## 0.0.5

- Refactor form fields, add custom widgets, and update assets

---

## 0.0.4

- Refactor form fields and add custom widgets
- Add PasswordField

---

## 0.0.3

- Added stepper

---

## 0.0.2

- Added reactive forms

---

## 0.0.1

- TODO: Describe initial release.
