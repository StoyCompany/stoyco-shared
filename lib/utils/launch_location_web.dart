import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enum representing the type of location launch - either via a search query or using specific coordinates.
enum LaunchLocationWebType { query, coordinates }

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
class LaunchLocationWebWidget extends StatelessWidget {
  /// Creates a [LaunchLocationWebWidget].
  ///
  /// The [key] is passed to the [super] constructor of [StatelessWidget].
  /// The [type] specifies the launch type, defaulting to using the available data.
  const LaunchLocationWebWidget({
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

  void _launchLocation() async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showException('Could not launch $url');
    }
  }

  /// Helper method to throw an exception with a specific [message].
  void _showException(String message) {
    throw Exception('Error launching location: $message');
  }

  /// Builds the widget with a styled [ElevatedButton] that triggers location launch on press.
  @override
  Widget build(BuildContext context) {
    // Condición para manejar diferentes estilos según la plataforma
    final buttonStyle = ButtonStyle(
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
    );

    return ElevatedButton(
      onPressed: () => _launchLocation(),
      style: buttonStyle,
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
}
