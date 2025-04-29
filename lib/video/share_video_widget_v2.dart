import 'dart:async';
import 'dart:io';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// A widget that allows users to share a video.
///
/// This widget provides a button that, when tapped, shares the provided video.
/// It offers customizable parameters for styling and behavior.
///
/// Example:
/// ```dart
/// ShareVideoWidgetV2(
///   video: myVideoModel,
///   onResultAction: () {
///     // Handle the result action
///   },
///   loading: isLoading,
///   paddingHorizontal: 16.0,
///   paddingVertical: 8.0,
///   borderRadius: 8.0,
///   iconWidth: 24.0,
///   textFontSize: 14.0,
///   spacing: 12.0,
///   splashColor: Colors.blue,
///   highlightColor: Colors.grey,
///   textColor: Colors.black,
///   iconColor: Colors.red,
/// )
/// ```
class ShareVideoWidgetV2 extends StatefulWidget {
  const ShareVideoWidgetV2({
    super.key,
    required this.video,
    required this.onResultAction,
    required this.loading,
    this.paddingHorizontal = 8.0,
    this.paddingVertical = 4.0,
    this.borderRadius = 4.0,
    this.iconWidth = 18.0,
    this.textFontSize = 12.0,
    this.spacing = 10.0,
    this.splashColor = const Color(0xFF4639E7),
    this.highlightColor = Colors.transparent,
    this.textColor = const Color(0xFFFAFAFA),
    this.iconColor,
  });

  /// The video to be shared.
  final VideoWithMetadata video;

  /// Callback executed after the share action completes.
  final VoidCallback onResultAction;

  /// Indicates whether the widget is in a loading state.
  final bool loading;

  /// Horizontal padding around the widget.
  final double paddingHorizontal;

  /// Vertical padding around the widget.
  final double paddingVertical;

  /// Border radius of the widget.
  final double borderRadius;

  /// Width of the share icon.
  final double iconWidth;

  /// Font size of the share text.
  final double textFontSize;

  /// Spacing between the icon and the text.
  final double spacing;

  /// Splash color when the widget is tapped.
  final Color splashColor;

  /// Highlight color when the widget is pressed.
  final Color highlightColor;

  /// Color of the share text.
  final Color textColor;

  /// Color of the share icon. If null, defaults based on loading state.
  final Color? iconColor;

  @override
  ShareVideoWidgetV2State createState() => ShareVideoWidgetV2State();
}

/// State for [ShareVideoWidgetV2].
class ShareVideoWidgetV2State extends State<ShareVideoWidgetV2> {
  String loadingText = 'Compartiendo';
  Timer? _timer;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
  }

  Duration calculateDuration(int score) {
    if (score <= 50) {
      return const Duration(milliseconds: 300);
    }
    if (score <= 100) {
      return const Duration(milliseconds: 500);
    }
    return const Duration(milliseconds: 1000);
  }

  /// Starts the sharing process and updates the loading state.
  void _startSharing() {
    setState(() {
      _isSharing = true;
      loadingText = 'Compartiendo';
    });
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (loadingText.length < 15) {
          loadingText += '.';
        } else {
          loadingText = 'Compartiendo';
        }
      });
    });
  }

  /// Stops the sharing process and resets the loading state.
  void _stopSharing() {
    setState(() {
      _isSharing = false;
      loadingText = 'Compartiendo';
    });
    _timer?.cancel();
  }

  /// Shares the video using the [share_plus] package.
  ///
  /// This method handles downloading the video, writing it to a temporary
  /// directory, and invoking the share dialog. It also manages the loading
  /// state and error handling.
  ///
  /// Example:
  /// ```dart
  /// _shareVideo();
  /// ```
  Future<void> _shareVideo() async {
    _startSharing();
    unawaited(HapticFeedback.lightImpact());
    final String videoUrl = widget.video.appUrl ?? '';
    final String videoName = widget.video.name ?? 'Video';
    final String videoDescription = widget.video.description ?? '';

    try {
      if (videoUrl.isEmpty) {
        StoyCoLogger.error('URL del video no disponible');
        _stopSharing();
        return;
      }

      await _shareOnMobile(videoUrl, videoName, videoDescription);

      widget.onResultAction();
    } catch (e) {
      StoyCoLogger.error('Error sharing video: $e');
    } finally {
      _stopSharing();
    }
  }

  Future<void> _shareOnMobile(
    String videoUrl,
    String videoName,
    String videoDescription,
  ) async {
    final response = await http.get(Uri.parse(videoUrl));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/video.mp4';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      final xFile = XFile(filePath);
      final shareText = 'Mira este video: $videoName\n$videoDescription';

      await Share.shareXFiles(
        [xFile],
        text: shareText,
        subject: videoName,
        fileNameOverrides: [videoName],
        sharePositionOrigin: Rect.fromCenter(
          center: Offset.zero,
          width: 0,
          height: 0,
        ),
      );
    } else {
      StoyCoLogger.error('Error downloading video: ${response.statusCode}');
      throw Exception('Error downloading video');
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.loading || _isSharing ? null : _shareVideo,
        child: Padding(
          padding: StoycoScreenSize.symmetric(
            context,
            horizontal: widget.paddingHorizontal,
            vertical: widget.paddingVertical,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
                width: StoycoScreenSize.width(context, widget.iconWidth),
                color:
                    widget.iconColor ?? (widget.loading ? Colors.grey : null),
              ),
              Gap(StoycoScreenSize.width(context, widget.spacing)),
              Text(
                _isSharing
                    ? loadingText
                    : (widget.loading ? 'Cargando...' : 'Compartir'),
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.w400,
                  fontSize:
                      StoycoScreenSize.width(context, widget.textFontSize),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
