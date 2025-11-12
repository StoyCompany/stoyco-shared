import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_interaction_content/stoyco_interaction_content.dart';
import 'package:stoyco_shared/announcement/widgets/cover_image_with_fade.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/design/skeleton_card.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// Abstract interface for content that can be displayed in InteractiveContentCard
abstract class InteractiveContent {
  String get id;
  String get title;
  String get mainImage;
  DateTime? get publishDate;
  DateTime? get endDate;
}



/// Adapter for FeedContentItem to InteractiveContent
class FeedContentAdapter implements InteractiveContent {
  const FeedContentAdapter(this.item);

  final FeedContentItem item;

  @override
  String get id => item.contentId;

  @override
  String get title => item.title;

  @override
  String get mainImage => item.mainImage;

  @override
  DateTime? get publishDate {
    try {
      return DateTime.parse(item.contentCreatedAt);
    } catch (e) {
      return null;
    }
  }

  @override
  DateTime? get endDate {
    try {
    return item.endDate != null ? DateTime.parse(item.endDate!) : null;
    } catch (e) {
      return null;
    }
  }
}

/// Configuration class for InteractiveContentCard appearance
class InteractiveCardConfig {

  const InteractiveCardConfig({
    this.height = 144.0,
    this.borderRadius = 20.0,
    this.spacing = 16.0,
    this.iconSize = 20.0,
    this.titleFontSize = 16.0,
    this.dateFontSize = 12.0,
    this.counterFontSize = 12.0,
    this.skeletonHeight = 16.0,
    this.titleMaxLines = 2,
    this.likedIconColor,
    this.unlikedIconColor,
    this.shareIconColor,
    this.textColor,
  });
  final double height;
  final double borderRadius;
  final double spacing;
  final double iconSize;
  final double titleFontSize;
  final double dateFontSize;
  final double counterFontSize;
  final double skeletonHeight;
  final int titleMaxLines;
  final Color? likedIconColor;
  final Color? unlikedIconColor;
  final Color? shareIconColor;
  final Color? textColor;

  /// Default configuration for news cards
  static const news = InteractiveCardConfig(
    height: 144.0,
    titleMaxLines: 2,
  );

  /// Default configuration for announcement cards
  static const announcement = InteractiveCardConfig(
    height: 160.0,
    titleMaxLines: 3,
    iconSize: 22.0,
  );
}


/// Callback definitions for interactions
typedef OnLikeCallback = Future<void> Function(String contentId, bool isLiked);
typedef OnShareCallback = Future<void> Function(String contentId);
typedef OnTapCallback = void Function(String contentId);
typedef OnLoadInteractionCountsCallback = Future<InteractionCounts> Function(String contentId);

/// A reusable interactive content card widget with social features.
/// 
/// This component follows best practices and can be used for:
/// - News articles
/// - Announcements (convocatorias)
/// - Feed content (generic)
/// - Any content requiring social interaction
///
/// The widget automatically loads interaction counts from Firestore via the
/// `onLoadInteractionCounts` callback. Initial values show as 0 while loading.
///
/// Example usage:
/// ```dart
/// InteractiveContentCard(
///   data: FeedContentAdapter(feedItem),
///   onLoadInteractionCounts: (contentId) async {
///     return await interactionService.getInteractionCounts(
///       contentId: contentId,
///     );
///   },
///   onLike: (contentId, isLiked) async {
///     await interactionService.likeContent(contentId, isLiked);
///   },
///   onShare: (contentId) async {
///     await interactionService.shareContent(contentId);
///   },
///   onTap: () => navigateToDetail(feedItem),
/// )
/// ```
class InteractiveContentCard extends StatefulWidget {
  const InteractiveContentCard({
    super.key,
    required this.data,
    this.config = const InteractiveCardConfig(),
    this.onTap,
    this.onLike,
    this.onShare,
    this.onLoadInteractionCounts,
    this.isLoading = false,
    this.enableLike = true,
    this.enableShare = true,
    this.enableViews = false,
    this.customDateFormatter,
  });

  /// Content data to display (use NewModelAdapter or FeedContentAdapter)
  final InteractiveContent data;

  /// Visual configuration
  final InteractiveCardConfig config;

  /// Loading state
  final bool isLoading;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when like is pressed
  final OnLikeCallback? onLike;

  /// Callback when share is pressed
  final OnShareCallback? onShare;

  /// Callback to load interaction counts from Firestore
  /// The widget will call this internally on mount and update counts automatically
  final OnLoadInteractionCountsCallback? onLoadInteractionCounts;

  /// Feature toggles
  final bool enableLike;
  final bool enableShare;
  final bool enableViews;

  /// Custom date formatter
  final String Function(DateTime)? customDateFormatter;


  /// Static loading card for shimmer effect
  static Widget loading({InteractiveCardConfig? config}) => _InteractiveContentCardLoading(
      config: config ?? const InteractiveCardConfig(),
    );

  @override
  State<InteractiveContentCard> createState() => _InteractiveContentCardState();
}

class _InteractiveContentCardState extends State<InteractiveContentCard>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  int _likeCount = 0;
  int _shareCount = 0;
  int _viewCount = 0;
  bool _isLoadingCounts = false;

  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;
  
  bool _isProcessingLike = false;
  bool _isProcessingShare = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadInteractionCounts();
  }

  Future<void> _loadInteractionCounts() async {
    if (widget.onLoadInteractionCounts == null) return;

    setState(() => _isLoadingCounts = true);

    try {
      final counts = await widget.onLoadInteractionCounts!(widget.data.id);
      if (mounted) {
        setState(() {
          _likeCount = counts.likes;
          _shareCount = counts.shares;
          _viewCount = counts.views;
          _isLiked = true ?? false;
        });
      }
    } catch (e) {
      StoyCoLogger.error('Error loading interaction counts: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingCounts = false);
      }
    }
  }

  void _setupAnimations() {
    _likeAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _likeScaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeAnimController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(InteractiveContentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload counts if content changed
    if (oldWidget.data.id != widget.data.id) {
      _loadInteractionCounts();
    }

  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  String _formatRelativeTime(DateTime date) {
    if (widget.customDateFormatter != null) {
      return widget.customDateFormatter!(date);
    }

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return weeks == 1 ? '1 semana' : '$weeks semanas';
    }
    
    // After 30 days, show DD/MM/YYYY format
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  Future<void> _handleLike() async {
    if (!widget.enableLike || _isProcessingLike) return;

    setState(() => _isProcessingLike = true);

    // Optimistic UI update
    final newLikedState = !_isLiked;
    setState(() {
      _isLiked = newLikedState;
      _likeCount += newLikedState ? 1 : -1;
    });

    // Animate
    if (newLikedState) {
      await _likeAnimController.forward();
      await _likeAnimController.reverse();
    }

    try {
      // Call API through callback
      await widget.onLike?.call(widget.data.id, newLikedState);
    } catch (e) {
      // Revert on error
      setState(() {
        _isLiked = !newLikedState;
        _likeCount += newLikedState ? -1 : 1;
      });
      StoyCoLogger.error('Error handling like: $e');
    } finally {
      setState(() => _isProcessingLike = false);
    }
  }

  Future<void> _handleShare() async {
    if (!widget.enableShare || _isProcessingShare) return;

    setState(() => _isProcessingShare = true);

    try {
      // Optimistically increment share count
      setState(() => _shareCount++);

      // Call API through callback
      await widget.onShare?.call(widget.data.id);
    } catch (e) {
      // Revert on error
      setState(() => _shareCount--);
      StoyCoLogger.error('Error sharing: $e');
    } finally {
      setState(() => _isProcessingShare = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return InteractiveContentCard.loading(config: widget.config);
    }

    return SizedBox(
      height: StoycoScreenSize.height(context, widget.config.height),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap != null 
              ? () => widget.onTap!()
              : null,
          borderRadius: BorderRadius.circular(
            StoycoScreenSize.radius(context, widget.config.borderRadius),
          ),
          splashColor: StoycoColors.blue.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = constraints.maxHeight;
        return Row(
          children: [
            _buildImage(context, imageSize),
            Gap(StoycoScreenSize.width(context, widget.config.spacing)),
            Expanded(child: _buildInfo(context)),
          ],
        );
      },
    );

  Widget _buildImage(BuildContext context, double size) => Hero(
      tag: 'content_image_${widget.data.id}',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                StoycoScreenSize.radius(context, widget.config.borderRadius),
              ),
              child: CoverImageWithFade(
                imageUrl: widget.data.mainImage,
                width: size,
                height: size,
              ),
            ),
            // Overlay icon for announcements only, without affecting image size
            if (widget.data.endDate != null)
              Positioned(
                top: StoycoScreenSize.height(context, 6),
                left: StoycoScreenSize.width(context, 6),
                child: Container(
                  padding: StoycoScreenSize.symmetric(
                    context,
                    horizontal: 32, // long horizontal padding for a pill shape
                    vertical: 8,    // small vertical padding for a slim badge
                    horizontalPhone: 24,
                    horizontalTablet: 28,
                  ),
                  decoration: BoxDecoration(
                    color: true
                        ? StoycoColors.royalIndigo.withValues(alpha: 0.7)
                        : StoycoColors.hint.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(32), // large for rounded ends
                    boxShadow: [
                      BoxShadow(
                        color: StoycoColors.shadowColor.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'packages/stoyco_shared/lib/assets/icons/megaphone_icon.svg',
                    width: StoycoScreenSize.width(context, 18), // icon size 18
                    height: StoycoScreenSize.width(context, 18),
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  Widget _buildInfo(BuildContext context) {
    final textColor = widget.config.textColor ?? StoycoColors.white2;

    return Padding(
      padding: StoycoScreenSize.symmetric(context, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.data.title,
            style: TextStyle(
              color: textColor,
              fontSize: StoycoScreenSize.fontSize(
                context,
                widget.config.titleFontSize,
              ),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            maxLines: widget.config.titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),

          Gap(StoycoScreenSize.height(context, 4)),

          if (widget.data.publishDate != null)
            Text(
              _formatRelativeTime(widget.data.publishDate!),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: StoycoScreenSize.fontSize(
                  context,
                  widget.config.dateFontSize,
                ),
              ),
            ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSocialActions(context, textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialActions(BuildContext context, Color baseColor) => Row(
      children: [
        if (widget.enableLike)
          _SocialButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            count: _likeCount,
            color: _isLiked
                ? (widget.config.likedIconColor ?? StoycoColors.white)
                : (widget.config.unlikedIconColor ?? baseColor),
            onPressed: _handleLike,
            isProcessing: _isProcessingLike,
            animation: _isLiked ? _likeScaleAnim : null,
            config: widget.config,
          ),
        if (widget.enableLike && widget.enableShare)
          Gap(StoycoScreenSize.width(context, 15)),
        if (widget.enableShare)
          _SocialButton(
            svgAsset: 'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
            count: _shareCount,
            color: widget.config.shareIconColor ?? baseColor,
            onPressed: _handleShare,
            isProcessing: _isProcessingShare,
            config: widget.config,
          ),
      ],
    );
  }

// Private widget for social buttons
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    this.icon,
    this.svgAsset,
    required this.count,
    required this.color,
    required this.onPressed,
    required this.isProcessing,
    required this.config,
    this.animation,
    this.isReadOnly = false,
  }) : assert(icon != null || svgAsset != null, 'Either icon or svgAsset must be provided');
  final IconData? icon;
  final String? svgAsset;
  final int count;
  final Color color;
  final VoidCallback onPressed;
  final bool isProcessing;
  final Animation<double>? animation;
  final InteractiveCardConfig config;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (svgAsset != null) {
      iconWidget = SvgPicture.asset(
        svgAsset!,
        width: StoycoScreenSize.width(context, config.iconSize),
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        icon!,
        size: StoycoScreenSize.width(context, config.iconSize),
        color: color,
      );
    }

    if (animation != null) {
      iconWidget = AnimatedBuilder(
        animation: animation!,
        builder: (_, child) => Transform.scale(
          scale: animation!.value,
          child: child,
        ),
        child: iconWidget,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isReadOnly ? null : (isProcessing ? null : onPressed),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              Gap(StoycoScreenSize.width(context, 4)),
              Text(
                _formatCount(count),
                style: TextStyle(
                  color: color,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    config.counterFontSize,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

// Loading state widget
class _InteractiveContentCardLoading extends StatelessWidget {

  const _InteractiveContentCardLoading({
    required this.config,
  });
  final InteractiveCardConfig config;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: StoycoScreenSize.height(context, config.height),
      child: Row(
        children: [
          SkeletonCard(
            width: StoycoScreenSize.height(context, config.height),
            height: StoycoScreenSize.height(context, config.height),
            borderRadius: BorderRadius.circular(
              StoycoScreenSize.radius(context, config.borderRadius),
            ),
          ),
          Gap(StoycoScreenSize.width(context, config.spacing)),
          Expanded(
            child: Padding(
              padding: StoycoScreenSize.symmetric(context, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  SkeletonCard(
                    width: double.infinity,
                    height: StoycoScreenSize.height(context, 24),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Gap(StoycoScreenSize.height(context, 8)),
                  // Social buttons skeleton
                  Row(
                    children: [
                      SkeletonCard(
                        width: StoycoScreenSize.width(context, 60),
                        height: StoycoScreenSize.height(context, 20),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      Gap(StoycoScreenSize.width(context, 20)),
                      SkeletonCard(
                        width: StoycoScreenSize.width(context, 60),
                        height: StoycoScreenSize.height(context, 20),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Date skeleton
                  SkeletonCard(
                    width: StoycoScreenSize.width(context, 80),
                    height: StoycoScreenSize.height(context, 16),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}