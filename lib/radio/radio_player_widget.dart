import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/radio/radio_player_config.dart';
import 'package:stoyco_shared/radio/radio_player_controller.dart';
import 'package:stoyco_shared/radio/radio_player_state.dart';

/// Displays the radio player controls and listener count for a single radio station.
///
/// Uses [RadioPlayerController] internally to manage playback state.
///
/// Example:
/// ```dart
/// RadioPlayerWidget(
///   config: RadioPlayerConfig(onPlayRadio: (radio) async => ...),
/// )
/// ```
class RadioPlayerWidget extends StatefulWidget {
  /// Creates a radio player widget.
  const RadioPlayerWidget({
    super.key,
    required this.config,
    this.fontFamily,
  });

  /// Configuration with callbacks for playback events.
  final RadioPlayerConfig config;

  /// Optional font family for text styling.
  final String? fontFamily;

  @override
  State<RadioPlayerWidget> createState() => _RadioPlayerWidgetState();
}

class _RadioPlayerWidgetState extends State<RadioPlayerWidget> {
  late RadioPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RadioPlayerController(config: widget.config);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: _controller.isLoadingListenable,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const SizedBox.shrink();
          }

          return ValueListenableBuilder<RadioPlayerState>(
            valueListenable: _controller.stateListenable,
            builder: (context, state, _) {
              if (state.radios.isEmpty) {
                return const SizedBox.shrink();
              }

              final currentRadio = state.radios.first;

              return RadioPlayerContent(
                radio: currentRadio,
                controller: _controller,
                fontFamily: widget.fontFamily,
              );
            },
          );
        },
      );
}

/// Content layout for the radio player.
///
/// Displays the player controls and listener count in a column.
class RadioPlayerContent extends StatelessWidget {
  /// Creates radio player content.
  const RadioPlayerContent({
    super.key,
    required this.radio,
    required this.controller,
    this.fontFamily,
  });

  /// The radio station to display.
  final RadioModel radio;

  /// Controller managing playback state.
  final RadioPlayerController controller;

  /// Optional font family for text styling.
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioPlayer(
            radio: radio,
            controller: controller,
            fontFamily: fontFamily,
          ),
          SizedBox(height: StoycoScreenSize.height(context, 15)),
          _ListenerCount(
            radioId: radio.id,
            initialCount: radio.membersOnlineCount,
            controller: controller,
            fontFamily: fontFamily,
          ),
        ],
      );
}

class _RadioPlayer extends StatelessWidget {
  const _RadioPlayer({
    required this.radio,
    required this.controller,
    this.fontFamily,
  });

  final RadioModel radio;
  final RadioPlayerController controller;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: controller.isPlayingListenable,
        builder: (context, isPlaying, _) => ValueListenableBuilder<bool>(
          valueListenable: controller.isBufferingListenable,
          builder: (context, isBuffering, _) {
            final isThisRadioPlaying = controller.isRadioPlaying(radio.id);
            final isCurrentRadio = controller.currentPlayingRadioId == radio.id;

            return _PlayerButton(
              radio: radio,
              isPlaying: isThisRadioPlaying,
              isBuffering: isBuffering && isCurrentRadio,
              isCurrentRadio: isCurrentRadio,
              controller: controller,
              fontFamily: fontFamily,
            );
          },
        ),
      );
}

class _PlayerButton extends StatelessWidget {
  const _PlayerButton({
    required this.radio,
    required this.isPlaying,
    required this.isBuffering,
    required this.isCurrentRadio,
    required this.controller,
    this.fontFamily,
  });

  final RadioModel radio;
  final bool isPlaying;
  final bool isBuffering;
  final bool isCurrentRadio;
  final RadioPlayerController controller;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isBuffering ? null : _handleTap,
        child: Container(
          padding: StoycoScreenSize.symmetric(
            context,
            horizontal: 15,
            vertical: 10.5,
          ),
          decoration: BoxDecoration(
            color: StoycoColors.darkSlateBlue,
            borderRadius: BorderRadius.circular(
              StoycoScreenSize.radius(context, 5),
            ),
          ),
          child: Row(
            children: [
              _PlayPauseIcon(
                isPlaying: isPlaying,
                isBuffering: isBuffering,
              ),
              SizedBox(width: StoycoScreenSize.width(context, 20)),
              Expanded(
                child: _RadioInfo(
                  radio: radio,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      );

  void _handleTap() {
    if (isCurrentRadio) {
      controller.togglePlayPause(radio.id);
    } else {
      controller.playRadio(radio);
    }
  }
}

class _PlayPauseIcon extends StatelessWidget {
  const _PlayPauseIcon({
    required this.isPlaying,
    required this.isBuffering,
  });

  final bool isPlaying;
  final bool isBuffering;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: StoycoScreenSize.width(context, 16.5),
        backgroundColor: StoycoColors.whiteLavender,
        child: isBuffering
            ? SizedBox(
                width: StoycoScreenSize.width(context, 18),
                height: StoycoScreenSize.width(context, 18),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: StoycoColors.charcoalGray,
                ),
              )
            : Icon(
                isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                color: StoycoColors.charcoalGray,
                size: StoycoScreenSize.width(context, 24),
              ),
      );
}

class _RadioInfo extends StatelessWidget {
  const _RadioInfo({
    required this.radio,
    this.fontFamily,
  });

  final RadioModel radio;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            radio.title,
            style: TextStyle(
              color: StoycoColors.whiteLavender,
              fontWeight: FontWeight.bold,
              fontSize: StoycoScreenSize.fontSize(context, 14),
              fontFamily: fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: StoycoScreenSize.height(context, 8)),
          Text(
            radio.description ?? 'Reproduciendo radio en vivo',
            style: TextStyle(
              color: StoycoColors.whiteLavender.withValues(alpha: 0.7),
              fontSize: StoycoScreenSize.fontSize(context, 12),
              fontFamily: fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}

class _ListenerCount extends StatelessWidget {
  const _ListenerCount({
    required this.radioId,
    required this.initialCount,
    required this.controller,
    this.fontFamily,
  });

  final String radioId;
  final int initialCount;
  final RadioPlayerController controller;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => StreamBuilder<int>(
        stream: controller.getListenerCount(radioId),
        initialData: initialCount,
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          return Align(
            alignment: Alignment.centerRight,
            child: Text(
              'LISTENING X $count',
              style: TextStyle(
                color: StoycoColors.whiteLavender,
                fontSize: StoycoScreenSize.fontSize(context, 10),
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
              ),
            ),
          );
        },
      );
}
