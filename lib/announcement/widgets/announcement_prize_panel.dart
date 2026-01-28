import 'package:flutter/material.dart';
import 'package:stoyco_shared/announcement/utils/announcement_details_utils.dart';
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
    this.paddingScrollBar,
    this.htmlStyle,
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

  /// Padding applied to the content when the scrollbar is visible.
  ///
  /// This property allows adding space between the scrollbar and the content.
  /// If null, [EdgeInsets.zero] will be used.
  ///
  /// This property is only applicable when [showScrollbar] is set to true.
  ///
  /// Example:
  /// ```dart
  /// AnnouncementPrizePanel(
  ///   prizeText: 'Your prize details here',
  ///   showScrollbar: true,
  ///   paddingScrollBar: EdgeInsets.only(right: 8.0),
  /// )
  /// ```
  ///
  /// When used with RTL languages, consider using [EdgeInsetsDirectional]:
  /// ```dart
  /// paddingScrollBar: EdgeInsetsDirectional.only(end: 8.0)
  /// ```
  final EdgeInsetsGeometry? paddingScrollBar;

  final CustomStylesBuilder? htmlStyle;

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
        child: Container(
          padding: StoycoScreenSize.all(
            context,
            20,
            phone: 16,
            tablet: 18,
            desktopLarge: 24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF202532),
            borderRadius: BorderRadius.circular(
              _responsiveRadius(
                AnnouncementPrizePanel._defaultBorderRadius,
                phone: 5,
                tablet: 18,
                desktopLarge: 24,
              ),
            ),
          ),
          child: widget.maxHeight != null
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.maxHeight!),
                  child: _buildScrollableContent(),
                )
              : HtmlWidget(
                  AnnouncementDetailsUtils.removeBackgroundColors(
                    widget.prizeText,
                  ),
                  customStylesBuilder:
                      widget.htmlStyle ?? _buildHtmlCustomStyles,
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
        customStylesBuilder: widget.htmlStyle ?? _buildHtmlCustomStyles,
        onTapUrl: _handleUrlTap,
      ),
    );

    return widget.showScrollbar
        ? Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: Padding(
              padding: widget.paddingScrollBar ?? EdgeInsets.zero,
              child: scrollView,
            ),
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
