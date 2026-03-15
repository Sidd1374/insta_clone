import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/insta_widget.dart' as wid;
import 'package:video_player/video_player.dart';

class InstaReelPost extends StatefulWidget {
  final String username;
  final String profileImage;
  final String videoPath;
  final String caption;
  final int likes;
  final int comments;
  final int shares;
  final String? ctaText;
  final bool isAd;
  final bool showFollowButton;

  const InstaReelPost({
    super.key,
    required this.username,
    required this.profileImage,
    required this.videoPath,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
    this.ctaText,
    this.isAd = false,
    this.showFollowButton = false,
  });

  @override
  State<InstaReelPost> createState() => _InstaReelPostState();
}

class _InstaReelPostState extends State<InstaReelPost> {
  late final VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        _controller.setLooping(true);
        _controller.setVolume(1.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    if (!_controller.value.isInitialized) {
      return;
    }

    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String formatNumber(int number) {
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
    final mediaHeight = MediaQuery.sizeOf(context).width.clamp(380.0, 520.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: mediaHeight,
              width: double.infinity,
              child: _controller.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(widget.profileImage),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.isAd)
                          const Text(
                            'Ad',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: [
                  if (widget.showFollowButton) ...[
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.white, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Follow'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      wid.optionsPosts_drawer(context);
                    },
                    child: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),

            if (widget.ctaText != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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
                ),
              ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 28,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      formatNumber(widget.likes),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 26,
                      color: theme.iconTheme.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatNumber(widget.comments),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.repeat, size: 26, color: theme.iconTheme.color),
                    const SizedBox(width: 6),
                    Text(
                      formatNumber(widget.shares),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.bookmark_border,
                  size: 26,
                  color: theme.iconTheme.color,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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

        const SizedBox(height: 16),
      ],
    );
  }
}
