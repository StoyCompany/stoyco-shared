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
  /// * [designPixels] The width value in design pixels to scale.
  ///
  /// Returns the scaled width according to the device's screen size.
  static double width(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalWidth = designPixels * scaleFactor;
    return finalWidth;
  }

  /// Responsive height based on the design pixels.
  ///
  /// * [designPixels] The height value in design pixels to scale.
  ///
  /// Returns the scaled height according to the device's screen size.
  static double height(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalHeight = designPixels * scaleFactor;
    return finalHeight;
  }

  /// Responsive font size based on the design pixels.
  ///
  /// * [designPixels] The font size in design pixels to scale.
  ///
  /// Returns the scaled font size, ensuring a minimum size of 10.
  static double fontSize(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalFontSize = designPixels * scaleFactor;
    return finalFontSize > 10 ? finalFontSize : 10;
  }

  /// Responsive border radius based on the design pixels.
  ///
  /// * [designPixels] The radius value in design pixels to scale.
  ///
  /// Returns the scaled radius according to the device's screen size.
  static double radius(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalRadius = designPixels * scaleFactor;
    return finalRadius;
  }

  /// Responsive EdgeInsets from left, top, right, bottom values.
  ///
  /// * [left] The left padding value in design pixels.
  /// * [top] The top padding value in design pixels.
  /// * [right] The right padding value in design pixels.
  /// * [bottom] The bottom padding value in design pixels.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object.
  static EdgeInsetsGeometry fromLTRB(
    BuildContext context, {
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      EdgeInsets.fromLTRB(
        width(context, left ?? 0),
        height(context, top ?? 0),
        width(context, right ?? 0),
        height(context, bottom ?? 0),
      );

  /// Responsive symmetric EdgeInsets.
  ///
  /// * [horizontal] The horizontal padding in design pixels.
  /// * [vertical] The vertical padding in design pixels.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object.
  static EdgeInsetsGeometry symmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        vertical: height(context, vertical),
        horizontal: width(context, horizontal),
      );

  /// Responsive EdgeInsets with equal padding on all sides.
  ///
  /// * [value] The padding value in design pixels.
  ///
  /// Returns a responsive [EdgeInsetsGeometry] object with equal padding.
  static EdgeInsetsGeometry all(BuildContext context, double value) =>
      EdgeInsets.all(width(context, value));

  /// Checks if the current device is a phone based on its width.
  ///
  /// Returns `true` if the device's width is less than the tablet reference width.
  static bool isPhone(BuildContext context) =>
      screenWidth(context) < _figmaTabletWidthReference;

  /// Checks if the current device is a tablet based on its width.
  ///
  /// Returns `true` if the device's width is between the tablet and desktop reference widths.
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= _figmaTabletWidthReference &&
        width < _figmaDesktopWidthReference;
  }

  /// Checks if the current device is a desktop based on its width.
  ///
  /// Returns `true` if the device's width is between the desktop and large desktop reference widths.
  static bool isDesktop(BuildContext context) {
    final width = screenWidth(context);
    return width >= _figmaDesktopWidthReference &&
        width < _figmaDesktopLargeWidthReference;
  }

  /// Checks if the current device is a large desktop based on its width.
  ///
  /// Returns `true` if the device's width is greater than or equal to the large desktop reference width.
  static bool isDesktopLarge(BuildContext context) =>
      screenWidth(context) >= _figmaDesktopLargeWidthReference;
}
