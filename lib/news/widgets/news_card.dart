import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/design/skeleton_card.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// A widget that displays a news card with an image, title, description, and other details.
///
/// The [NewsCard] can be in a loading state, in which case it shows skeleton placeholders.
/// When not loading, it displays the data provided by [newData].
///
/// The card is tappable if [onTap] is provided and [isLoading] is false.
class NewsCard extends StatelessWidget {
  /// Creates a [NewsCard].
  ///
  /// The [newData] must be provided if [isLoading] is false.
  const NewsCard({
    super.key,
    this.onTap,
    this.newData,
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
  }) : assert(newData != null || isLoading);

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether the card is in a loading state.
  final bool isLoading;

  /// The data to display in the card.
  final NewModel? newData;

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
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    late String formattedDate = '';

    try {
      if (newData != null) {
        final date = DateTime.parse(
                newData?.scheduledPublishDate ?? newData?.createdAt ?? '')
            .toLocal();
        formattedDate = date.year == currentYear
            ? DateFormat('MMM dd | HH:mm').format(date)
            : DateFormat('MMM dd - yyyy | HH:mm').format(date);
      }
    } catch (e) {
      StoyCoLogger.info('Error parsing date: $e');
    }

    return SizedBox(
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
                              color: StoycoColors.shadowColor.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: !isLoading
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            StoycoScreenSize.radius(context, borderRadius),
                          ),
                          child: newData?.mainImage != null
                              ? CachedNetworkImage(
                                  imageUrl: newData?.mainImage ?? '',
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
                            StoycoScreenSize.radius(context, borderRadius),
                          ),
                        ),
                ),
                Gap(StoycoScreenSize.width(context, spacing)),
                Expanded(
                  child: Padding(
                    padding: StoycoScreenSize.symmetric(context, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isLoading)
                          Row(
                            children: [
                              SvgPicture.asset(
                                'packages/stoyco_shared/lib/assets/icons/calendar_icon.svg',
                                width: StoycoScreenSize.width(
                                  context,
                                  iconSize,
                                ),
                                height: StoycoScreenSize.height(
                                  context,
                                  iconSize,
                                ),
                              ),
                              Gap(StoycoScreenSize.width(context, 5)),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: StoycoColors.white2,
                                  fontSize: StoycoScreenSize.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ],
                          )
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
                            newData?.title ?? '',
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
                                  newData?.shortDescription ?? '',
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
                            '${newData?.viewCount ?? 0} views',
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
}
