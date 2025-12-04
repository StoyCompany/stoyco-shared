import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/models/radio_model.dart';

/// State for the radio player (loading, playing, paused, changing)
enum RadioPlayerState {
  loading,
  playing,
  paused,
  changingStation,
  error,
}

/// Widget for displaying and controlling radio playback
/// This widget is designed to be reusable across different parts of the app
class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({
    super.key,
    required this.radio,
    required this.state,
    required this.onTap,
    this.fontFamily,
    this.errorMessage,
  });

  /// The radio model to display
  final RadioModel radio;

  /// Current state of the radio player
  final RadioPlayerState state;

  /// Callback when the player is tapped
  final VoidCallback onTap;

  /// Optional font family for text
  final String? fontFamily;

  /// Error message to display when state is error
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: state == RadioPlayerState.changingStation ? null : onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: StoycoScreenSize.height(context, 10),
          right: StoycoScreenSize.width(context, 15),
          bottom: StoycoScreenSize.height(context, 10),
          left: StoycoScreenSize.width(context, 15),
        ),
        decoration: BoxDecoration(
          color: StoycoColors.darkSlateBlue,
          borderRadius: BorderRadius.circular(
            StoycoScreenSize.radius(context, 5),
          ),
        ),
        child: Row(
          children: [
            _buildPlayPauseButton(context),
            SizedBox(width: StoycoScreenSize.width(context, 20)),
            Expanded(
              child: _buildRadioInfo(context),
            ),
          ],
        ),
      ),
    );

  Widget _buildPlayPauseButton(BuildContext context) => CircleAvatar(
      radius: StoycoScreenSize.width(context, 16.5),
      backgroundColor: StoycoColors.white2,
      child: _buildButtonContent(context),
    );

  Widget _buildButtonContent(BuildContext context) {
    if (state == RadioPlayerState.changingStation ||
        state == RadioPlayerState.loading) {
      return SizedBox(
        width: StoycoScreenSize.width(context, 16),
        height: StoycoScreenSize.width(context, 16),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: StoycoColors.charcoalGray,
        ),
      );
    }

    return Icon(
      state == RadioPlayerState.playing ? Icons.pause : Icons.play_arrow_rounded,
      color: StoycoColors.charcoalGray,
      size: StoycoScreenSize.width(context, 24),
    );
  }

  Widget _buildRadioInfo(BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          radio.title,
          style: TextStyle(
            color: StoycoColors.white2,
            fontWeight: FontWeight.bold,
            fontSize: StoycoScreenSize.fontSize(context, 14),
            fontFamily: fontFamily,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: StoycoScreenSize.height(context, 4)),
        Text(
          radio.description ?? 'Now Playing',
          style: TextStyle(
            color: StoycoColors.white2.withValues(alpha: 0.7),
            fontSize: StoycoScreenSize.fontSize(context, 12),
            fontFamily: fontFamily,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
}

/// Empty state widget when no radios are available
class RadioPlayerEmptyWidget extends StatelessWidget {
  const RadioPlayerEmptyWidget({
    super.key,
    this.message = 'No hay radios disponibles',
    this.fontFamily,
  });

  final String message;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => Center(
      child: Text(
        message,
        style: TextStyle(
          color: StoycoColors.white2.withValues(alpha: 0.7),
          fontSize: StoycoScreenSize.fontSize(context, 14),
          fontFamily: fontFamily,
        ),
      ),
    );
}

/// Loading state widget for radio player
class RadioPlayerLoadingWidget extends StatelessWidget {
  const RadioPlayerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: CircularProgressIndicator(color: StoycoColors.white2),
    );
}

/// Error state widget for radio player
class RadioPlayerErrorWidget extends StatelessWidget {
  const RadioPlayerErrorWidget({
    super.key,
    required this.errorMessage,
    this.fontFamily,
  });

  final String errorMessage;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 30),
        child: Text(
          errorMessage,
          style: TextStyle(
            color: StoycoColors.white2.withValues(alpha: 0.7),
            fontSize: StoycoScreenSize.fontSize(context, 14),
            fontFamily: fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
}
