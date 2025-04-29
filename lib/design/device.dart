/// Determines the type of device based on the screen width.
///
/// This function uses predefined change points to categorize the device
/// into one of the following types:
/// - [DeviceType.mobile]: for screen widths less than or equal to 600 pixels.
/// - [DeviceType.tablet]: for screen widths greater than 600 pixels but less than or equal to 1200 pixels.
/// - [DeviceType.desktop]: for screen widths greater than 1200 pixels but less than or equal to 1600 pixels.
/// - [DeviceType.desktopLarge]: for screen widths greater than 1600 pixels.
///
/// The change points are defined as:
/// - [tabletChangePoint]: 600 pixels
/// - [desktopChangePoint]: 1200 pixels
/// - [desktopLargeChangePoint]: 1600 pixels
///
/// The function takes a [BuildContext] as a parameter to access the screen width
/// using the [MediaQuery] class.
///
/// Example usage:
/// ```dart
/// DeviceType deviceType = getDeviceType(context);
/// ```
///
/// Returns a [DeviceType] value representing the type of device.
library;

import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop, desktopLarge }

const double desktopLargeChangePoint = 1600;
const double desktopChangePoint = 1200;
const double tabletChangePoint = 600;

DeviceType getDeviceType(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth > desktopLargeChangePoint) {
    return DeviceType.desktopLarge;
  } else if (screenWidth > desktopChangePoint) {
    return DeviceType.desktop;
  } else if (screenWidth > tabletChangePoint) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}
