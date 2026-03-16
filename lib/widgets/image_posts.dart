import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/widgets/insta_widget.dart' as wid;

enum PostType { normal, sponsored, ad }

class InstaPost extends StatefulWidget {
  final String username;
  final String profileImage;
  final List<String> postImages;
  final String caption;
  final int likes;
  final int comments;
  final int reshares;
  final int shares;
  final int saves;
  final PostType postType;
  final String? subLabel;
  final String? ctaText;
  final bool showFollowButton;

  const InstaPost({
    super.key,
    required this.username,
    required this.profileImage,
    required this.postImages,
    required this.caption,
    required this.likes,
    this.comments = 0,
    this.reshares = 0,
    this.shares = 0,
    this.saves = 0,
    this.postType = PostType.normal,
    this.subLabel,
    this.ctaText,
    this.showFollowButton = false,
  });

  @override
  State<InstaPost> createState() => _InstaPostState();
}

class _InstaPostState extends State<InstaPost> {
  int currentIndex = 0;
  late final PageController _pageController;
  bool _liked = false;
  bool _commented = false;
  bool _reshared = false;
  bool _shared = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
    });
  }

  void _toggleComment() {
    setState(() {
      _commented = !_commented;
    });
  }

  void _toggleShare() {
    setState(() {
      _shared = !_shared;
    });
  }

  void _toggleReshare() {
    setState(() {
      _reshared = !_reshared;
    });
  }

  void _toggleSave() {
    setState(() {
      _saved = !_saved;
    });
  }

  String _formatCount(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final mediaHeight = screenWidth.clamp(300.0, 430.0);
    final baseIconColor = theme.iconTheme.color ?? colorScheme.onSurface;
    final likeColor = _liked ? colorScheme.error : baseIconColor;
    final commentColor = _commented ? colorScheme.primary : baseIconColor;
    final reshareColor = _reshared ? colorScheme.primary : baseIconColor;
    final shareColor = _shared ? colorScheme.primary : baseIconColor;
    final saveColor = _saved ? colorScheme.primary : baseIconColor;
    final actionCountStyle = textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(widget.profileImage),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (widget.postType == PostType.normal &&
                      widget.subLabel != null)
                    Text(
                      widget.subLabel!,
                      style: textTheme.bodySmall?.copyWith(
                        color: textTheme.bodyMedium?.color,
                      ),
                    ),
                  if (widget.postType == PostType.sponsored)
                    Text('Sponsored', style: textTheme.bodySmall),
                  if (widget.postType == PostType.ad)
                    Text('Ad', style: textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              if (widget.showFollowButton) ...[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Follow'),
                ),
                const SizedBox(width: 4),
              ],
              GestureDetector(
                onTap: () {
                  wid.optionsPosts_drawer(context);
                },
                child: SvgPicture.asset(
                  'assets/icons/24x/Options.svg',
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(baseIconColor, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            SizedBox(
              height: mediaHeight,
              width: double.infinity,
              child: widget.postImages.isEmpty
                  ? Container(color: theme.dividerColor)
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: widget.postImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          widget.postImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: theme.dividerColor);
                          },
                        );
                      },
                    ),
            ),
            if (widget.postImages.length > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${currentIndex + 1}/${widget.postImages.length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (widget.postType == PostType.ad && widget.ctaText != null)
          Container(
            width: double.infinity,
            color: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Text(
                  widget.ctaText!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/24x/Next.svg',
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _liked
                          ? 'assets/icons/24x/Like_Filled.svg'
                          : 'assets/icons/24x/Like.svg',
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(likeColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(widget.likes + (_liked ? 1 : 0)),
                      style: actionCountStyle?.copyWith(color: likeColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: _toggleComment,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _commented
                          ? 'assets/icons/24x/Text.svg'
                          : 'assets/icons/24x/Comment.svg',
                      width: 26,
                      height: 26,
                      colorFilter: ColorFilter.mode(
                        commentColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(widget.comments + (_commented ? 1 : 0)),
                      style: actionCountStyle?.copyWith(color: commentColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: _toggleReshare,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _reshared
                          ? 'assets/icons/24x/Repost_Filled.svg'
                          : 'assets/icons/24x/Repost.svg',
                      width: 26,
                      height: 26,
                      colorFilter: ColorFilter.mode(
                        reshareColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(widget.reshares + (_reshared ? 1 : 0)),
                      style: actionCountStyle?.copyWith(color: reshareColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: _toggleShare,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _shared
                          ? 'assets/icons/24x/share_2026_filled.svg'
                          : 'assets/icons/24x/share_2026.svg',
                      width: 26,
                      height: 26,
                      colorFilter: ColorFilter.mode(
                        shareColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(widget.shares + (_shared ? 1 : 0)),
                      style: actionCountStyle?.copyWith(color: shareColor),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleSave,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      _saved
                          ? 'assets/icons/24x/Save_Filled.svg'
                          : 'assets/icons/24x/Save.svg',
                      width: 26,
                      height: 26,
                      colorFilter: ColorFilter.mode(saveColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(widget.saves + (_saved ? 1 : 0)),
                      style: actionCountStyle?.copyWith(color: saveColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${widget.likes} likes',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '${widget.username} ',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: widget.caption,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
