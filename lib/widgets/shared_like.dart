import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/widgets/social_button.dart';

class SharedLike extends StatefulWidget {
  const SharedLike({
    super.key,
    required this.seeLike,
    required this.seeShared,
    this.likedIconColor,
    this.unlikedIconColor,
    required this.baseColor,
    this.shareIconColor,
    required this.likeTap,
    required this.sharedTap,
    required this.iconSize,
    required this.counterFontSize, 
    required this.likeCount, 
    required this.shareCount, 
    required this.isLiked, 
    required this.isProcessingLike, 
    required this.isProcessingShare, 
    this.isVertical = false,
  });
  final bool seeLike;
  final bool seeShared;
  final Color? likedIconColor;
  final Color? unlikedIconColor;
  final Color baseColor;
  final Color? shareIconColor;
  final Function(bool) likeTap;
  final VoidCallback sharedTap;
  final double iconSize;
  final double counterFontSize;
  final int likeCount;
  final int shareCount;
  final bool isLiked;
  final bool isProcessingLike;
  final bool isProcessingShare;
  final bool isVertical;

  @override
  State<SharedLike> createState() => _SharedLikeState();
}

class _SharedLikeState extends State<SharedLike> with TickerProviderStateMixin {
  late Animation<double> _likeScaleAnim;
  late AnimationController _likeAnimController;

  Future<void> _handleLike() async {
    if (!widget.seeLike) return;
    widget.likeTap(!widget.isLiked);
  }

  Future<void> _handleShare() async {
    if (!widget.seeShared) return;
    widget.sharedTap();
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
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => !widget.isVertical ? Row(
        children: [
          if (widget.seeLike)
            SocialButton(
              icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
              count: widget.likeCount,
              color: widget.isLiked
                  ? (widget.likedIconColor ?? StoycoColors.white)
                  : (widget.unlikedIconColor ?? widget.baseColor),
              onPressed: _handleLike,
              isProcessing: widget.isProcessingLike,
              animation: widget.isLiked ? _likeScaleAnim : null,
              iconSize: widget.iconSize,
              counterFontSize: widget.counterFontSize,
            ),
          if (widget.seeLike && widget.seeShared)
            Gap(StoycoScreenSize.width(context, 15)),
          if (widget.seeShared)
            SocialButton(
              svgAsset:
                  'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
              count: widget.shareCount,
              color: widget.shareIconColor ?? widget.baseColor,
              onPressed: _handleShare,
              isProcessing: widget.isProcessingShare,
              iconSize: widget.iconSize,
              counterFontSize: widget.counterFontSize,
            ),
        ],
      ) : Column(
        children: [
          if (widget.seeLike)
            SocialButton(
              icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
              count: widget.likeCount,
              color: widget.isLiked
                  ? (widget.likedIconColor ?? StoycoColors.white)
                  : (widget.unlikedIconColor ?? widget.baseColor),
              onPressed: _handleLike,
              isProcessing: widget.isProcessingLike,
              animation: widget.isLiked ? _likeScaleAnim : null,
              iconSize: widget.iconSize,
              counterFontSize: widget.counterFontSize,
            ),
          if (widget.seeLike && widget.seeShared)
            Gap(StoycoScreenSize.height(context, 15)),
          if (widget.seeShared)
            SocialButton(
              svgAsset:
                  'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
              count: widget.shareCount,
              color: widget.shareIconColor ?? widget.baseColor,
              onPressed: _handleShare,
              isProcessing: widget.isProcessingShare,
              iconSize: widget.iconSize,
              counterFontSize: widget.counterFontSize,
            ),
        ],
      );
}
