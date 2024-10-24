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
