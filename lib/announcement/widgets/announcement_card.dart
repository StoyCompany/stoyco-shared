import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/design/skeleton_card.dart';

/// A customizable card widget that displays announcement information with rich styling.
///
/// The [AnnouncementCard] displays announcements with an image, title, description, and view count.
/// It supports a loading state with skeleton placeholders and can be configured with various
/// visual properties.
///
/// ## Features:
/// - Loading state with skeleton placeholders
/// - Customizable dimensions and styling
/// - Active/Inactive status indicator
/// - View count display
/// - Tap interaction
///
/// ## Example usage:
///
/// ```dart
/// // Display a loading announcement card
/// AnnouncementCard(
///   isLoading: true,
///   height: 144.0,
/// )
///
/// // Display an announcement with data
/// AnnouncementCard(
///   announcementData: AnnouncementModel(
///     id: '1',
///     title: 'Important Update',
///     shortDescription: 'New features have been added to the platform.',
///     mainImage: 'https://example.com/image.jpg',
///     isActive: true,
///     viewCount: 123,
///   ),
///   onTap: () => print('Announcement tapped'),
/// )
///
/// // Customized announcement card
/// AnnouncementCard(
///   announcementData: announcement,
///   height: 160.0,
///   borderRadius: 16.0,
///   titleFontSize: 18.0,
///   onTap: () => Navigator.push(
///     context,
///     MaterialPageRoute(
///       builder: (context) => AnnouncementDetailScreen(id: announcement.id),
///     ),
///   ),
/// )
/// ```
class AnnouncementCard extends StatelessWidget {
  /// Creates a customizable announcement card.
  ///
  /// The [announcementData] must be provided if [isLoading] is false.
  /// If [isLoading] is true, the card will display skeleton placeholders.
  ///
  /// The [onTap] callback will be triggered when the card is tapped, unless
  /// [isLoading] is true.
  const AnnouncementCard({
    super.key,
    this.onTap,
    this.announcementData,
    this.isLoading = false,
    this.height = 144.0,
    this.borderRadius = 20.0,
    this.spacing = 16.0,
    this.iconSize = 14.85,
    this.titleFontSize = 16.0,
    this.descriptionFontSize = 10.0,
    this.viewsFontSize = 10.0,
    this.skeletonHeight = 16.0,
    this.titleMaxLines = 4,
  }) : assert(announcementData != null || isLoading);

  /// Callback function triggered when the card is tapped.
  ///
  /// This callback is only active when [isLoading] is false.
  /// Typically used to navigate to a detail page or show more information.
  final VoidCallback? onTap;

  /// Determines if the card is in a loading state.
  ///
  /// When true, skeleton placeholders are shown instead of announcement content.
  /// Default is false.
  final bool isLoading;

  /// The announcement data to display in the card.
  ///
  /// Must be provided when [isLoading] is false. Contains information such as
  /// title, description, image URL, and view count.
  final AnnouncementModel? announcementData;

  /// The height of the card in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 144.0.
  final double height;

  /// The border radius of the card corners in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 20.0.
  final double borderRadius;

  /// The horizontal spacing between the image and text content in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 16.0.
  final double spacing;

  /// The size of the status icon (e.g., megaphone) in logical pixels.
  ///
  /// Default is 14.85.
  final double iconSize;

  /// The font size for the announcement title in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 16.0.
  final double titleFontSize;

  /// The font size for the announcement description in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 10.0.
  final double descriptionFontSize;

  /// The font size for the views count text in logical pixels.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 10.0.
  final double viewsFontSize;

  /// The height of skeleton placeholder elements when in loading state.
  ///
  /// This will be adapted based on the device screen size using [StoycoScreenSize].
  /// Default is 16.0.
  final double skeletonHeight;

  /// The maximum number of lines to display for the title text.
  ///
  /// When the text exceeds this number of lines, it will be truncated with an ellipsis.
  /// Default is 4.
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: StoycoScreenSize.height(context, height),
        child: InkWell(
          onTap: !isLoading ? onTap : null,
          borderRadius: BorderRadius.circular(
            StoycoScreenSize.radius(context, borderRadius),
          ),
          splashColor: StoycoColors.blue.withOpacity(0.5),
          highlightColor: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final containerHeight = constraints.maxHeight;
              return Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: containerHeight,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            StoycoScreenSize.radius(context, borderRadius),
                          ),
                          boxShadow: !isLoading
                              ? [
                                  BoxShadow(
                                    color: StoycoColors.shadowColor
                                        .withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: !isLoading
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  StoycoScreenSize.radius(
                                    context,
                                    borderRadius,
                                  ),
                                ),
                                child: announcementData?.mainImage != null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            announcementData?.mainImage ?? '',
                                        placeholder: (context, url) =>
                                            const SkeletonCard(),
                                        errorWidget: (context, url, error) =>
                                            const SkeletonCard(),
                                        fit: BoxFit.cover,
                                      )
                                    : const SkeletonCard(),
                              )
                            : SkeletonCard(
                                borderRadius: BorderRadius.circular(
                                  StoycoScreenSize.radius(
                                    context,
                                    borderRadius,
                                  ),
                                ),
                              ),
                      ),
                      if (!isLoading && announcementData != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: StoycoScreenSize.symmetric(
                              context,
                              horizontal: 12.5,
                              vertical: 6.5,
                            ),
                            decoration: BoxDecoration(
                              color: announcementData!.isActive
                                  ? StoycoColors.royalIndigo.withOpacity(0.7)
                                  : StoycoColors.hint.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(
                                StoycoScreenSize.radius(context, 100),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      StoycoColors.shadowColor.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'packages/stoyco_shared/lib/assets/icons/megaphone_icon.svg',
                                  colorFilter: ColorFilter.mode(
                                    StoycoColors.white2,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (!announcementData!.isActive) ...[
                                  Gap(StoycoScreenSize.width(context, 5)),
                                  Text(
                                    'CERRADO',
                                    style: TextStyle(
                                      color: StoycoColors.white2,
                                      fontSize:
                                          StoycoScreenSize.fontSize(context, 8),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap(StoycoScreenSize.width(context, spacing)),
                  Expanded(
                    child: Padding(
                      padding: StoycoScreenSize.symmetric(context, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLoading)
                            Container()
                          else
                            SkeletonCard(
                              width: double.infinity,
                              height: StoycoScreenSize.height(
                                context,
                                skeletonHeight,
                              ),
                              borderRadius: BorderRadius.circular(
                                StoycoScreenSize.radius(context, 5),
                              ),
                            ),
                          Gap(StoycoScreenSize.height(context, 4)),
                          if (!isLoading)
                            Text(
                              announcementData?.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: StoycoColors.white2,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  titleFontSize,
                                ),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                            )
                          else
                            SkeletonCard(
                              width: double.infinity,
                              height: StoycoScreenSize.height(context, 24),
                              borderRadius: BorderRadius.circular(
                                StoycoScreenSize.radius(context, 5),
                              ),
                            ),
                          Gap(StoycoScreenSize.height(context, 4)),
                          Expanded(
                            child: !isLoading
                                ? Text(
                                    announcementData?.shortDescription ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: StoycoColors.white2,
                                      fontSize: StoycoScreenSize.fontSize(
                                        context,
                                        descriptionFontSize,
                                      ),
                                      height: StoycoScreenSize.height(
                                            context,
                                            16,
                                          ) /
                                          StoycoScreenSize.fontSize(
                                            context,
                                            descriptionFontSize,
                                          ),
                                    ),
                                    maxLines: titleMaxLines,
                                  )
                                : SkeletonCard(
                                    borderRadius: BorderRadius.circular(
                                      StoycoScreenSize.radius(context, 5),
                                    ),
                                  ),
                          ),
                          Gap(StoycoScreenSize.height(context, 4)),
                          if (!isLoading)
                            Text(
                              '${announcementData?.viewCount ?? 0} views',
                              style: TextStyle(
                                color: StoycoColors.white2,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  viewsFontSize,
                                ),
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          else
                            SkeletonCard(
                              height: StoycoScreenSize.height(
                                context,
                                skeletonHeight,
                              ),
                              borderRadius: BorderRadius.circular(
                                StoycoScreenSize.radius(context, 5),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
}
