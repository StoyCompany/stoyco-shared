import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/utils/colors.dart';
import 'package:maps_launcher/maps_launcher.dart';

/// Enum representing the type of location launch - either via a search query or using specific coordinates.
enum LaunchLocationType { query, coordinates }

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
    this.query,
    this.coordinates,
    this.type,
    this.padding,
    this.textStyle,
  }) : assert(
          query != null || coordinates != null,
          'Either query or coordinates must be provided.',
        );

  /// A search query for the location. This is optional and used if [type] is [LaunchLocationType.query].
  final String? query;

  /// Coordinates of the location. This is optional and used if [type] is [LaunchLocationType.coordinates].
  final Coordinates? coordinates;

  /// The type of location launch, which can be specified explicitly. If not provided, it is inferred from provided parameters.
  final LaunchLocationType? type;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  /// Launches the location based on the provided [type], [query], or [coordinates].
  ///
  /// If no valid location is provided, it throws an exception.
  void _launchLocation() {
    print('El query es: $query');
    try {
      final effectiveType = type ??
          (query != null
              ? LaunchLocationType.query
              : LaunchLocationType.coordinates);

      switch (effectiveType) {
        case LaunchLocationType.query:
          if (query != null) {
            try {
              MapsLauncher.launchQuery(query!);
            } catch (e) {
              print('El error del map es es: $e');
            }
          } else {
            _showException('No query provided.');
          }
        case LaunchLocationType.coordinates:
          if (coordinates != null) {
            MapsLauncher.launchCoordinates(
              coordinates!.latitude,
              coordinates!.longitude,
            );
          } else {
            _showException('No coordinates provided.');
          }
      }
    } catch (e) {
      print('El error es: $e');
    }
  }

  /// Helper method to throw an exception with a specific [message].
  void _showException(String message) {
    throw Exception('Error launching location: $message');
  }

  /// Builds the widget with a styled [ElevatedButton] that triggers location launch on press.
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => _launchLocation(),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            padding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xff252836),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(
              color: StoycoColors.text,
              fontSize: 10,
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
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
