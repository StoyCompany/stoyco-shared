import 'package:flutter/material.dart';

/// A custom text button widget for StoyCo app.
///
/// This widget displays a customizable text button with various properties such as text, onTap callback,
/// height, width, loading indicator, background color, font size, and font weight.
///
/// Example usage:
///
/// ```dart
/// TextButtonStoyco(
///   text: 'Click me',
///   onTap: () {
///     // Handle button tap
///   },
///   height: 50,
///   width: 115,
///   isLoading: false,
///   backgroundColor: Colors.blue,
///   fontSize: 16,
///   fontWeight: FontWeight.w400,
///   loadingIndicatorSize: 24.0,
/// )
/// ```
///
/// The `loadingIndicatorSize` parameter controls the size of the circular progress indicator
/// shown when `isLoading` is true.

class TextButtonStoyco extends StatelessWidget {
  const TextButtonStoyco(
      {super.key,
      required this.text,
      required this.onTap,
      this.height = 50,
      this.width = 115,
      this.isLoading = false,
      this.backgroundColor,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w400,
      this.boxShadow,
      this.loadingIndicatorSize = 24.0,
      this.textStyle,
      this.radius = 16});

  final String text;
  final VoidCallback onTap;
  final double height;
  final double width;
  final bool isLoading;
  final Color? backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final List<BoxShadow>? boxShadow;
  final double loadingIndicatorSize;
  final TextStyle? textStyle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final center = Center(
      child: isLoading
          ? SizedBox(
              width: loadingIndicatorSize,
              height: loadingIndicatorSize,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAFAFA)),
              ),
            )
          : Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontFamily: 'Akkurat_Pro',
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    height: 1.19,
                    letterSpacing: 0,
                    color: const Color(0xFFF2F2FA),
                    decoration: TextDecoration.none,
                  ),
            ),
    );
    return SizedBox(
      height: height,
      width: width,
      child: MouseRegion(
        cursor: backgroundColor == null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: backgroundColor,
              gradient: backgroundColor == null
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1C197F),
                        Color(0xFF4639E7),
                      ],
                    )
                  : null,
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: const Color(0xFF2B3445).withOpacity(0.5),
                      offset: const Offset(0, -20),
                      blurRadius: 30,
                    ),
                    const BoxShadow(
                      color: Color(0xFF10141C),
                      offset: Offset(0, 20),
                      blurRadius: 30,
                    ),
                  ],
            ),
            child: center,
          ),
        ),
      ),
    );
  }
}

class OutlinedTextButtonStoyco extends StatelessWidget {
  const OutlinedTextButtonStoyco({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 50,
    this.width = 115,
    this.isLoading = false,
    this.backgroundColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.textStyle,
  });

  final String text;
  final VoidCallback onTap;
  final double height;
  final double width;
  final bool isLoading;
  final Color? backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final center = Center(
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAFAFA)),
            )
          : Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontFamily: 'Akkurat_Pro',
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    height: 1.19,
                    letterSpacing: 0,
                    color: const Color(0xFFFAFAFA),
                    decoration: TextDecoration.none,
                  ),
            ),
    );
    return SizedBox(
      height: height,
      width: width,
      child: MouseRegion(
        cursor: backgroundColor == null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: backgroundColor,
              border: Border.all(color: const Color(0xFF4639E7)),
              gradient: backgroundColor == null
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1b1e2f),
                        Color(0xFF0d1623),
                      ],
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B3445).withOpacity(0.5),
                  offset: const Offset(0, -20),
                  blurRadius: 30,
                ),
                const BoxShadow(
                  color: Color(0xFF10141C),
                  offset: Offset(0, 20),
                  blurRadius: 30,
                ),
              ],
            ),
            child: center,
          ),
        ),
      ),
    );
  }
}
