import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/design/skeleton_card.dart';

/// A widget that displays a announcements card with an image, title, description, and other details.
///
/// The [AnnouncementCard] can be in a loading state, in which case it shows skeleton placeholders.
/// When not loading, it displays the data provided by [announcementData].
///
/// The card is tappable if [onTap] is provided and [isLoading] is false.
class AnnouncementCard extends StatelessWidget {
  /// Creates a [AnnouncementCard].
  ///
  /// The [announcementData] must be provided if [isLoading] is false.
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

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether the card is in a loading state.
  final bool isLoading;

  /// The data to display in the card.
  final AnnouncementModel? announcementData;

  /// The height of the card.
  final double height;

  /// The border radius of the card.
  final double borderRadius;

  /// The spacing between elements in the card.
  final double spacing;

  /// The size of the icon displayed in the card.
  final double iconSize;

  /// The font size of the title text.
  final double titleFontSize;

  /// The font size of the description text.
  final double descriptionFontSize;

  /// The font size of the views text.
  final double viewsFontSize;

  /// The height of the skeleton placeholders.
  final double skeletonHeight;

  /// The maximum number of lines for the title text.
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
