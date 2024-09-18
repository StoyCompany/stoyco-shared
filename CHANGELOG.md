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

- **feat:** Update "Como llegar" button style in LaunchLocationWidget

  The style of the "Como llegar" button in LaunchLocationWidget has been updated to handle different styles depending on the platform. A condition was added to apply specific styles when running on the web. In addition, the padding, background color, text color, and minimum button size styles were adjusted.

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
