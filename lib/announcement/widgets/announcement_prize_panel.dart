import 'package:flutter/material.dart';
import 'package:stoyco_shared/announcement/utils/announcement_details_utils.dart';
import 'package:stoyco_shared/announcement/widgets/gradient_container.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AnnouncementPrizePanel extends StatefulWidget {
  const AnnouncementPrizePanel({
    super.key,
    required this.prizeText,
    this.maxHeight,
    this.scrollDirection = Axis.vertical,
    this.scrollPhysics,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.reverse = false,
    this.primary,
    this.padding,
    this.showScrollbar = false,
  });

  final String prizeText;
  final double? maxHeight;
  final Axis scrollDirection;
  final ScrollPhysics? scrollPhysics;
  final Clip clipBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool reverse;
  final bool? primary;
  final EdgeInsetsGeometry? padding;
  final bool showScrollbar;
  static const double _defaultBorderRadius = 20.0;

  @override
  State<AnnouncementPrizePanel> createState() => _AnnouncementPrizePanelState();
}

class _AnnouncementPrizePanelState extends State<AnnouncementPrizePanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: InteractiveGradientPanel(
          padding: StoycoScreenSize.all(
            context,
            20,
            phone: 16,
            tablet: 18,
            desktopLarge: 24,
          ),
          showBorder: true,
          borderRadiusValue: _responsiveRadius(
            AnnouncementPrizePanel._defaultBorderRadius,
            phone: 16,
            tablet: 18,
            desktopLarge: 24,
          ),
          child: widget.maxHeight != null
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.maxHeight!),
                  child: _buildScrollableContent(),
                )
              : HtmlWidget(
                  AnnouncementDetailsUtils.removeBackgroundColors(
                      widget.prizeText),
                  customStylesBuilder: _buildHtmlCustomStyles,
                  onTapUrl: _handleUrlTap,
                ),
        ),
      );

  Widget _buildScrollableContent() {
    final scrollView = SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: widget.scrollDirection,
      physics: widget.scrollPhysics,
      clipBehavior: widget.clipBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      reverse: widget.reverse,
      primary: widget.primary,
      padding: widget.padding,
      child: HtmlWidget(
        AnnouncementDetailsUtils.removeBackgroundColors(widget.prizeText),
        customStylesBuilder: _buildHtmlCustomStyles,
        onTapUrl: _handleUrlTap,
      ),
    );

    return widget.showScrollbar
        ? Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: scrollView,
          )
        : scrollView;
  }

  double _responsiveRadius(
    double radius, {
    double? phone,
    double? tablet,
    double? desktopLarge,
  }) =>
      StoycoScreenSize.radius(
        context,
        radius,
        phone: phone ?? radius * 0.8,
        tablet: tablet ?? radius * 0.9,
        desktopLarge: desktopLarge ?? radius * 1.2,
      );

  Map<String, String>? _buildHtmlCustomStyles(dynamic element) =>
      AnnouncementDetailsUtils.buildHtmlCustomStyles(
        context: context,
        element: element,
      );

  Future<bool> _handleUrlTap(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }
}
