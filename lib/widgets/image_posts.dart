import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/insta_widget.dart' as wid;

enum PostType { normal, sponsored, ad }

class InstaPost extends StatefulWidget {
  final String username;
  final String profileImage;
  final List<String> postImages;
  final String caption;
  final int likes;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final mediaHeight = screenWidth.clamp(300.0, 430.0);

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
                child: Icon(Icons.more_vert, color: theme.iconTheme.color),
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
                Icon(
                  Icons.arrow_forward_ios,
                  color: colorScheme.onPrimary,
                  size: 16,
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 28,
                color: theme.iconTheme.color,
              ),
              const SizedBox(width: 14),
              Icon(
                Icons.chat_bubble_outline,
                size: 26,
                color: theme.iconTheme.color,
              ),
              const SizedBox(width: 14),
              Icon(Icons.send_outlined, size: 26, color: theme.iconTheme.color),
              const Spacer(),
              Icon(
                Icons.bookmark_border,
                size: 26,
                color: theme.iconTheme.color,
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
