import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/device.dart';

class StoycoScreenSize {
  /// Desktop
  static double _figmaDesktopWidthReference = 1440;
  static double _figmaDesktopHeightReference = 1024;

  /// Desktop Large
  static double _figmaDesktopLargeWidthReference = 1920;
  static double _figmaDesktopLargeHeightReference = 1080;

  /// Tablet
  static double _figmaTabletWidthReference = 768;
  static double _figmaTabletHeightReference = 1024;

  /// Mobile
  static double _figmaMobileWidthReference = 390;
  static double _figmaMobileHeightReference = 844;

  /// Set reference dimensions for Desktop
  static void setReferenceDimensions(double width, double height) {
    _figmaDesktopWidthReference = width;
    _figmaDesktopHeightReference = height;
  }

  /// Set reference dimensions for Desktop Large
  static void setReferenceDimensionsDesktopLarge(double width, double height) {
    _figmaDesktopLargeWidthReference = width;
    _figmaDesktopLargeHeightReference = height;
  }

  /// Set reference dimensions for Tablet
  static void setReferenceDimensionsTablet(double width, double height) {
    _figmaTabletWidthReference = width;
    _figmaTabletHeightReference = height;
  }

  /// Set reference dimensions for Mobile
  static void setReferenceDimensionsMobile(double width, double height) {
    _figmaMobileWidthReference = width;
    _figmaMobileHeightReference = height;
  }

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Calculate the scale factor based on device type and screen size
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
      default:
        // Fallback to desktop if device type is unrecognized
        referenceWidth = _figmaDesktopWidthReference;
        referenceHeight = _figmaDesktopHeightReference;
    }

    final deviceAspectRatio = screenWidth / screenHeight;
    final referenceAspectRatio = referenceWidth / referenceHeight;
    final aspectRatioDiff = deviceAspectRatio / referenceAspectRatio;

    return aspectRatioDiff >= 1
        ? screenWidth / referenceWidth
        : screenHeight / referenceHeight;
  }

  /// Responsive width
  static double width(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalWidth = designPixels * scaleFactor;
    return finalWidth;
  }

  /// Responsive height
  static double height(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalHeight = designPixels * scaleFactor;
    return finalHeight;
  }

  /// Responsive font size
  static double fontSize(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalFontSize = designPixels * scaleFactor;
    return finalFontSize > 10 ? finalFontSize : 10;
  }

  /// Responsive radius
  static double radius(BuildContext context, double designPixels) {
    final scaleFactor = _scaleFactor(context);
    final finalRadius = designPixels * scaleFactor;
    return finalRadius;
  }

  /// Responsive EdgeInsets from left, top, right, bottom
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

  /// Responsive symmetric EdgeInsets
  static EdgeInsetsGeometry symmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        vertical: height(context, vertical),
        horizontal: width(context, horizontal),
      );

  /// Responsive all EdgeInsets
  static EdgeInsetsGeometry all(BuildContext context, double value) =>
      EdgeInsets.all(
        width(context, value),
      );
  static bool isPhone(BuildContext context) =>
      screenWidth(context) < _figmaTabletWidthReference;

  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= _figmaTabletWidthReference &&
        width < _figmaDesktopWidthReference;
  }

  static bool isDesktop(BuildContext context) {
    final width = screenWidth(context);
    return width >= _figmaDesktopWidthReference &&
        width < _figmaDesktopLargeWidthReference;
  }

  static bool isDesktopLarge(BuildContext context) =>
      screenWidth(context) >= _figmaDesktopLargeWidthReference;
}
