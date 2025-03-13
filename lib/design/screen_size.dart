import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/device.dart';

/// Utility class for managing responsive screen dimensions and scaling
/// based on the device type and screen size. This class helps in adjusting
/// the design elements (such as width, height, font size, padding) to fit
/// different screen types like mobile, tablet, desktop, and large desktop.
class StoycoScreenSize {
  /// Reference width and height for Desktop design in Figma.
  static double _figmaDesktopWidthReference = 1440;
  static double _figmaDesktopHeightReference = 1024;

  /// Reference width and height for Large Desktop design in Figma.
  static double _figmaDesktopLargeWidthReference = 1920;
  static double _figmaDesktopLargeHeightReference = 1080;

  /// Reference width and height for Tablet design in Figma.
  static double _figmaTabletWidthReference = 768;
  static double _figmaTabletHeightReference = 1024;

  /// Reference width and height for Mobile design in Figma.
  static double _figmaMobileWidthReference = 390;
  static double _figmaMobileHeightReference = 844;

  /// Set reference dimensions for Desktop design.
  ///
  /// * [width] The new reference width for Desktop.
  /// * [height] The new reference height for Desktop.
  static void setReferenceDimensions(double width, double height) {
    _figmaDesktopWidthReference = width;
    _figmaDesktopHeightReference = height;
  }

  /// Set reference dimensions for Large Desktop design.
  ///
  /// * [width] The new reference width for Large Desktop.
  /// * [height] The new reference height for Large Desktop.
  static void setReferenceDimensionsDesktopLarge(double width, double height) {
    _figmaDesktopLargeWidthReference = width;
    _figmaDesktopLargeHeightReference = height;
  }

  /// Set reference dimensions for Tablet design.
  ///
  /// * [width] The new reference width for Tablet.
  /// * [height] The new reference height for Tablet.
  static void setReferenceDimensionsTablet(double width, double height) {
    _figmaTabletWidthReference = width;
    _figmaTabletHeightReference = height;
  }

  /// Set reference dimensions for Mobile design.
  ///
  /// * [width] The new reference width for Mobile.
  /// * [height] The new reference height for Mobile.
  static void setReferenceDimensionsMobile(double width, double height) {
    _figmaMobileWidthReference = width;
    _figmaMobileHeightReference = height;
  }

  /// Retrieve the current screen width in pixels.
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Retrieve the current screen height in pixels.
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Calculate the scale factor based on the device type and screen size.
  ///
  /// The scale factor is determined by comparing the current device's
  /// aspect ratio and screen dimensions to the Figma reference dimensions
  /// for the detected device type (mobile, tablet, desktop, etc.).
  static double _scaleFactor(BuildContext context) {
    final deviceType = getDeviceType(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double referenceWidth;
    double referenceHeight;

    switch (deviceType) {
      case DeviceType.desktopLarge:
        referenceWidth = _figmaDesktopLargeWidthReference;
        referenceHeight = _figmaDesktopLargeHeightReference;
      case DeviceType.desktop:
        referenceWidth = _figmaDesktopWidthReference;
        referenceHeight = _figmaDesktopHeightReference;
      case DeviceType.mobile:
        referenceWidth = _figmaMobileWidthReference;
        referenceHeight = _figmaMobileHeightReference;
      case DeviceType.tablet:
        referenceWidth = _figmaTabletWidthReference;
        referenceHeight = _figmaTabletHeightReference;
    }

    final deviceAspectRatio = screenWidth / screenHeight;
    final referenceAspectRatio = referenceWidth / referenceHeight;
    final aspectRatioDiff = deviceAspectRatio / referenceAspectRatio;

    return aspectRatioDiff >= 1
        ? screenWidth / referenceWidth
        : screenHeight / referenceHeight;
  }

  /// Responsive width based on the design pixels.
  ///
  /// * [designPixels] The default width value in design pixels to scale.
  /// * [phone] Optional width value for phone devices.
  /// * [tablet] Optional width value for tablet devices.
  /// * [desktop] Optional width value for desktop devices.
  /// * [desktopLarge] Optional width value for large desktop devices.
  ///
  /// Returns the scaled width according to the device's screen size.
  static double width(
    BuildContext context,
    double designPixels, {
    double? phone,
    double? tablet,
    double? desktop,
    double? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    double value;

    switch (deviceType) {
      case DeviceType.mobile:
        value = phone ?? designPixels;
      case DeviceType.tablet:
        value = tablet ?? designPixels;
      case DeviceType.desktop:
        value = desktop ?? designPixels;
      case DeviceType.desktopLarge:
        value = desktopLarge ?? designPixels;
    }

    final scaleFactor = _scaleFactor(context);
    return value * scaleFactor;
  }

  /// Responsive height based on the design pixels.
  ///
  /// * [designPixels] The default height value in design pixels to scale.
  /// * [phone] Optional height value for phone devices.
  /// * [tablet] Optional height value for tablet devices.
  /// * [desktop] Optional height value for desktop devices.
  /// * [desktopLarge] Optional height value for large desktop devices.
  ///
  /// Returns the scaled height according to the device's screen size.
  static double height(
    BuildContext context,
    double designPixels, {
    double? phone,
    double? tablet,
    double? desktop,
    double? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    double value;

    switch (deviceType) {
      case DeviceType.mobile:
        value = phone ?? designPixels;
      case DeviceType.tablet:
        value = tablet ?? designPixels;
      case DeviceType.desktop:
        value = desktop ?? designPixels;
      case DeviceType.desktopLarge:
        value = desktopLarge ?? designPixels;
    }

    final scaleFactor = _scaleFactor(context);
    return value * scaleFactor;
  }

  /// Responsive font size based on the design pixels.
  ///
  /// * [designPixels] The default font size in design pixels to scale.
  /// * [phone] Optional font size value for phone devices.
  /// * [tablet] Optional font size value for tablet devices.
  /// * [desktop] Optional font size value for desktop devices.
  /// * [desktopLarge] Optional font size value for large desktop devices.
  ///
  /// Returns the scaled font size, ensuring a minimum size of 10.
  static double fontSize(
    BuildContext context,
    double designPixels, {
    double? phone,
    double? tablet,
    double? desktop,
    double? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    double value;

    switch (deviceType) {
      case DeviceType.mobile:
        value = phone ?? designPixels;
      case DeviceType.tablet:
        value = tablet ?? designPixels;
      case DeviceType.desktop:
        value = desktop ?? designPixels;
      case DeviceType.desktopLarge:
        value = desktopLarge ?? designPixels;
    }

    final scaleFactor = _scaleFactor(context);
    final finalFontSize = value * scaleFactor;
    return finalFontSize > 10 ? finalFontSize : 10;
  }

  /// Responsive border radius based on the design pixels.
  ///
  /// * [designPixels] The default radius value in design pixels to scale.
  /// * [phone] Optional radius value for phone devices.
  /// * [tablet] Optional radius value for tablet devices.
  /// * [desktop] Optional radius value for desktop devices.
  /// * [desktopLarge] Optional radius value for large desktop devices.
  ///
  /// Returns the scaled radius according to the device's screen size.
  static double radius(
    BuildContext context,
    double designPixels, {
    double? phone,
    double? tablet,
    double? desktop,
    double? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    double value;

    switch (deviceType) {
      case DeviceType.mobile:
        value = phone ?? designPixels;
      case DeviceType.tablet:
        value = tablet ?? designPixels;
      case DeviceType.desktop:
        value = desktop ?? designPixels;
      case DeviceType.desktopLarge:
        value = desktopLarge ?? designPixels;
    }

    final scaleFactor = _scaleFactor(context);
    return value * scaleFactor;
  }

  /// Responsive EdgeInsets from left, top, right, bottom values.
  ///
  /// Each parameter can have specific values for different device types.
  ///
  /// * [left] The left padding value or default design pixels.
  /// * [top] The top padding value or default design pixels.
  /// * [right] The right padding value or default design pixels.
  /// * [bottom] The bottom padding value or default design pixels.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object.
  static EdgeInsetsGeometry fromLTRB(
    BuildContext context, {
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? leftPhone,
    double? topPhone,
    double? rightPhone,
    double? bottomPhone,
    double? leftTablet,
    double? topTablet,
    double? rightTablet,
    double? bottomTablet,
    double? leftDesktop,
    double? topDesktop,
    double? rightDesktop,
    double? bottomDesktop,
    double? leftDesktopLarge,
    double? topDesktopLarge,
    double? rightDesktopLarge,
    double? bottomDesktopLarge,
  }) {
    final deviceType = getDeviceType(context);

    double leftValue = left ?? 0;
    double topValue = top ?? 0;
    double rightValue = right ?? 0;
    double bottomValue = bottom ?? 0;

    switch (deviceType) {
      case DeviceType.mobile:
        leftValue = leftPhone ?? leftValue;
        topValue = topPhone ?? topValue;
        rightValue = rightPhone ?? rightValue;
        bottomValue = bottomPhone ?? bottomValue;
      case DeviceType.tablet:
        leftValue = leftTablet ?? leftValue;
        topValue = topTablet ?? topValue;
        rightValue = rightTablet ?? rightValue;
        bottomValue = bottomTablet ?? bottomValue;
      case DeviceType.desktop:
        leftValue = leftDesktop ?? leftValue;
        topValue = topDesktop ?? topValue;
        rightValue = rightDesktop ?? rightValue;
        bottomValue = bottomDesktop ?? bottomValue;
      case DeviceType.desktopLarge:
        leftValue = leftDesktopLarge ?? leftValue;
        topValue = topDesktopLarge ?? topValue;
        rightValue = rightDesktopLarge ?? rightValue;
        bottomValue = bottomDesktopLarge ?? bottomValue;
    }

    return EdgeInsets.fromLTRB(
      width(context, leftValue),
      height(context, topValue),
      width(context, rightValue),
      height(context, bottomValue),
    );
  }

  /// Responsive EdgeInsets with equal padding on all sides.
  ///
  /// * [value] The default padding value in design pixels.
  /// * [phone] Optional padding value for phone devices.
  /// * [tablet] Optional padding value for tablet devices.
  /// * [desktop] Optional padding value for desktop devices.
  /// * [desktopLarge] Optional padding value for large desktop devices.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object with equal padding.
  static EdgeInsetsGeometry all(
    BuildContext context,
    double value, {
    double? phone,
    double? tablet,
    double? desktop,
    double? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);
    double finalValue;

    switch (deviceType) {
      case DeviceType.mobile:
        finalValue = phone ?? value;
      case DeviceType.tablet:
        finalValue = tablet ?? value;
      case DeviceType.desktop:
        finalValue = desktop ?? value;
      case DeviceType.desktopLarge:
        finalValue = desktopLarge ?? value;
    }

    return EdgeInsets.all(width(context, finalValue));
  }

  /// Responsive symmetric EdgeInsets.
  ///
  /// * [horizontal] The default horizontal padding in design pixels.
  /// * [vertical] The default vertical padding in design pixels.
  /// * [horizontalPhone] Optional horizontal padding for phone devices.
  /// * [verticalPhone] Optional vertical padding for phone devices.
  /// * [horizontalTablet] Optional horizontal padding for tablet devices.
  /// * [verticalTablet] Optional vertical padding for tablet devices.
  /// * [horizontalDesktop] Optional horizontal padding for desktop devices.
  /// * [verticalDesktop] Optional vertical padding for desktop devices.
  /// * [horizontalDesktopLarge] Optional horizontal padding for large desktop devices.
  /// * [verticalDesktopLarge] Optional vertical padding for large desktop devices.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object.
  static EdgeInsetsGeometry symmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
    double? horizontalPhone,
    double? verticalPhone,
    double? horizontalTablet,
    double? verticalTablet,
    double? horizontalDesktop,
    double? verticalDesktop,
    double? horizontalDesktopLarge,
    double? verticalDesktopLarge,
  }) {
    final deviceType = getDeviceType(context);

    double finalHorizontal = horizontal;
    double finalVertical = vertical;

    switch (deviceType) {
      case DeviceType.mobile:
        finalHorizontal = horizontalPhone ?? horizontal;
        finalVertical = verticalPhone ?? vertical;
      case DeviceType.tablet:
        finalHorizontal = horizontalTablet ?? horizontal;
        finalVertical = verticalTablet ?? vertical;
      case DeviceType.desktop:
        finalHorizontal = horizontalDesktop ?? horizontal;
        finalVertical = verticalDesktop ?? vertical;
      case DeviceType.desktopLarge:
        finalHorizontal = horizontalDesktopLarge ?? horizontal;
        finalVertical = verticalDesktopLarge ?? vertical;
    }

    return EdgeInsets.symmetric(
      vertical: height(context, finalVertical),
      horizontal: width(context, finalHorizontal),
    );
  }

  /// Checks if the current device is a phone based on its width.
  ///
  /// Returns `true` if the device's width is less than the tablet reference width.
  static bool isPhone(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.mobile;
  }

  /// Checks if the current device is a tablet based on its width.
  ///
  /// Returns `true` if the device's width is between the tablet and desktop reference widths.
  static bool isTablet(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.tablet;
  }

  /// Checks if the current device is a desktop based on its width.
  ///
  /// Returns `true` if the device's width is between the desktop and large desktop reference widths.
  static bool isDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktop;
  }

  /// Checks if the current device is a large desktop based on its width.
  ///
  /// Returns `true` if the device's width is greater than or equal to the large desktop reference width.
  static bool isDesktopLarge(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktopLarge;
  }
}
