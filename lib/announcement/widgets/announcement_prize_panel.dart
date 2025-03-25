import 'package:flutter/material.dart';
import 'package:stoyco_shared/announcement/utils/announcement_details_utils.dart';
import 'package:stoyco_shared/announcement/widgets/gradient_container.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AnnouncementPrizePanel extends StatefulWidget {
  const AnnouncementPrizePanel({super.key, required this.prizeText});

  final String prizeText;
  static const double _defaultBorderRadius = 20.0;

  @override
  State<AnnouncementPrizePanel> createState() => _AnnouncementPrizePanelState();
}

class _AnnouncementPrizePanelState extends State<AnnouncementPrizePanel> {
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
          child: HtmlWidget(
            widget.prizeText,
            customStylesBuilder: _buildHtmlCustomStyles,
            onTapUrl: _handleUrlTap,
          ),
        ),
      );

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
