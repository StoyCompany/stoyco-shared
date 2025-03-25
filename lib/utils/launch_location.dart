import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:stoyco_shared/design/colors.dart';

/// A class to hold latitude and longitude data.
class Coordinates {
  /// Constructs an instance of [Coordinates].
  ///
  /// Requires [longitude] and [latitude] to be initialized.
  Coordinates({required this.longitude, required this.latitude});

  /// Longitude value of the coordinates.
  final double longitude;

  /// Latitude value of the coordinates.
  final double latitude;
}

/// A widget for launching a location using either a query or coordinates.
///
/// Requires one of [query] or [coordinates] to be provided. An [assert] ensures that at least one is present.
class LaunchLocationWidget extends StatelessWidget {
  /// Creates a [LaunchLocationWidget].
  ///
  /// The [key] is passed to the [super] constructor of [StatelessWidget].
  /// The [type] specifies the launch type, defaulting to using the available data.
  const LaunchLocationWidget({
    super.key,
    this.title,
    required this.coordinates,
    this.padding,
    this.textStyle,
  });

  /// Coordinates of the location.
  final Coordinates coordinates;

  final String? title;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  void _launchLocation() {
    MapLauncher.showMarker(
      coords: Coords(
        coordinates.latitude,
        coordinates.longitude,
      ),
      title: title ?? 'Location',
      mapType: Platform.isIOS ? MapType.apple : MapType.google,
    );
  }

  /// Builds the widget with a styled [ElevatedButton] that triggers location launch on press.
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => _launchLocation(),
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            padding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color(0xff252836),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              color: StoycoColors.text,
              fontSize: 10,
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(111, 32),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Como llegar',
                style: textStyle ??
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Gap(9),
            SvgPicture.asset(
              'packages/stoyco_shared/lib/assets/icons/location_icon.svg',
              height: 16,
              width: 16,
            ),
          ],
        ),
      );
}
