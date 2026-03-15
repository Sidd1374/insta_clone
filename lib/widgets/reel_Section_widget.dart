import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'insta_widget.dart';

Widget reelsSection(
  BuildContext context, {
  required List<Map<String, dynamic>> reels,
}) {
  return _ReelsView(reels: reels);
}

class _ReelsView extends StatefulWidget {
  final List<Map<String, dynamic>> reels;

  const _ReelsView({required this.reels});

  @override
  State<_ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<_ReelsView> {
  final PageController _pageController = PageController();
  bool showFriends = false;
  bool createActive = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendProfiles = widget.reels
        .map((reel) => reel['profile']?.toString() ?? '')
        .where((path) => path.isNotEmpty)
        .take(2)
        .toList();

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.reels.length,
          itemBuilder: (context, index) {
            final reel = widget.reels[index];

            return _ReelItem(reel: reel);
          },
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _ReelsHeader(
            showFriends: showFriends,
            createActive: createActive,
            friendProfiles: friendProfiles,
            onCreateTap: () {
              setState(() {
                createActive = !createActive;
              });
            },
            onShowFriendsChanged: (value) {
              setState(() {
                showFriends = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _ReelItem extends StatefulWidget {
  final Map<String, dynamic> reel;

  const _ReelItem({required this.reel});

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  bool liked = false;
  bool commented = false;
  bool reposted = false;
  bool shared = false;
  bool saved = false;
  bool optionsActive = false;
  bool following = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final actionRight = 16.0;

    final actionBottom = height * 0.02;

    final captionLeft = 16.0;

    final captionRight = 80.0;

    final captionBottom = height * 0.02;

    return Stack(
      children: [
        _ReelVideo(video: widget.reel['video']),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.62),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          right: actionRight,
          bottom: actionBottom,
          child: _ReelActions(
            reel: widget.reel,
            liked: liked,
            commented: commented,
            reposted: reposted,
            shared: shared,
            saved: saved,
            optionsActive: optionsActive,
            onLikeTap: () {
              setState(() {
                liked = !liked;
              });
            },
            onCommentTap: () {
              setState(() {
                commented = !commented;
              });
            },
            onRepostTap: () {
              setState(() {
                reposted = !reposted;
              });
            },
            onShareTap: () {
              setState(() {
                shared = !shared;
              });
            },
            onSaveTap: () {
              setState(() {
                saved = !saved;
              });
            },
            onOptionsTap: () {
              setState(() {
                optionsActive = !optionsActive;
                optionsPosts_drawer(context);
              });
            },
          ),
        ),

        Positioned(
          left: captionLeft,
          right: captionRight,
          bottom: captionBottom,
          child: _ReelCaption(
            reel: widget.reel,
            following: following,
            onFollowTap: () {
              setState(() {
                following = !following;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _ReelVideo extends StatefulWidget {
  final String video;

  const _ReelVideo({required this.video});

  @override
  State<_ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<_ReelVideo> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        controller.play();
        controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _ReelActions extends StatelessWidget {
  final Map<String, dynamic> reel;
  final bool liked;
  final bool commented;
  final bool reposted;
  final bool shared;
  final bool saved;
  final bool optionsActive;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onRepostTap;
  final VoidCallback onShareTap;
  final VoidCallback onSaveTap;
  final VoidCallback onOptionsTap;

  const _ReelActions({
    required this.reel,
    required this.liked,
    required this.commented,
    required this.reposted,
    required this.shared,
    required this.saved,
    required this.optionsActive,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onRepostTap,
    required this.onShareTap,
    required this.onSaveTap,
    required this.onOptionsTap,
  });

  Widget _musicCover(BuildContext context) {
    final coverPath = reel['musicCover']?.toString();

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: (coverPath != null && coverPath.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  coverPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 18,
                    );
                  },
                ),
              )
            : const Icon(Icons.music_note, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _action(
    BuildContext context, {
    required String inactiveIconAsset,
    required String activeIconAsset,
    required String count,
    required bool active,
    required VoidCallback onTap,
    required Color activeColor,
    double activeScale = 1.0,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final iconSize = (width * 0.078).clamp(24.0, 30.0);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: active ? activeScale : 1.0,
              duration: const Duration(milliseconds: 140),
              child: SvgPicture.asset(
                active ? activeIconAsset : inactiveIconAsset,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  active ? activeColor : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            count,
            style: textTheme.labelSmall?.copyWith(
              color: active ? activeColor : Colors.white,
              fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final likeActiveColor = colorScheme.error;

    return Column(
      children: [
        _action(
          context,
          inactiveIconAsset: 'assets/icons/24x/Like.svg',
          activeIconAsset: 'assets/icons/24x/Like_Filled.svg',
          count: reel['likes'],
          active: liked,
          onTap: onLikeTap,
          activeColor: likeActiveColor,
        ),
        _action(
          context,
          inactiveIconAsset: 'assets/icons/24x/Comment.svg',
          activeIconAsset: 'assets/icons/24x/Comment.svg',
          count: reel['comments'],
          active: commented,
          onTap: onCommentTap,
          activeColor: Colors.white,
          activeScale: 1.1,
        ),
        _action(
          context,
          inactiveIconAsset: 'assets/icons/24x/Repost.svg',
          activeIconAsset: 'assets/icons/24x/Repost_Filled.svg',
          count: (reel['reposts'] ?? reel['shares']).toString(),
          active: reposted,
          onTap: onRepostTap,
          activeColor: Colors.white,
        ),
        _action(
          context,
          inactiveIconAsset: 'assets/icons/24x/share_2026.svg',
          activeIconAsset: 'assets/icons/24x/share_2026_filled.svg',
          count: reel['shares'].toString(),
          active: shared,
          onTap: onShareTap,
          activeColor: Colors.white,
        ),
        _action(
          context,
          inactiveIconAsset: 'assets/icons/24x/Save.svg',
          activeIconAsset: 'assets/icons/24x/Save_Filled.svg',
          count: reel['saves'].toString(),
          active: saved,
          onTap: onSaveTap,
          activeColor: Colors.white,
        ),
        GestureDetector(
          onTap: onOptionsTap,
          child: Icon(Icons.more_vert, color: Colors.white),
        ),
        const SizedBox(height: 14),
        _musicCover(context),
      ],
    );
  }
}

class _ReelCaption extends StatefulWidget {
  final Map<String, dynamic> reel;
  final bool following;
  final VoidCallback onFollowTap;

  const _ReelCaption({
    required this.reel,
    required this.following,
    required this.onFollowTap,
  });

  @override
  State<_ReelCaption> createState() => _ReelCaptionState();
}

class _ReelCaptionState extends State<_ReelCaption> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final reel = widget.reel;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(reel["profile"]),
            ),
            const SizedBox(width: 8),
            Text(
              reel["username"],
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (reel["verified"] == true)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.verified,
                  color: colorScheme.primary,
                  size: 16,
                ),
              ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: widget.onFollowTap,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // reduce curve
                ),
                side: BorderSide(
                  color: widget.following ? Colors.transparent : Colors.white,
                ),
                backgroundColor: widget.following
                    ? Colors.white24
                    : Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                textStyle: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(widget.following ? 'Following' : 'Follow'),
            ),
          ],
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Text(
            reel["caption"],
            maxLines: expanded ? null : 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            const Icon(Icons.music_note, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                reel["music"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReelsHeader extends StatelessWidget {
  final bool showFriends;
  final bool createActive;
  final List<String> friendProfiles;
  final VoidCallback onCreateTap;
  final ValueChanged<bool> onShowFriendsChanged;

  const _ReelsHeader({
    required this.showFriends,
    required this.createActive,
    required this.friendProfiles,
    required this.onCreateTap,
    required this.onShowFriendsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = (width * 0.052).clamp(18.0, 22.0);
    final secondarySize = (width * 0.046).clamp(15.0, 19.0);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: onCreateTap,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onShowFriendsChanged(false),
                    child: Row(
                      children: [
                        Text(
                          'Reels',
                          style: TextStyle(
                            color: showFriends ? Colors.grey : Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => onShowFriendsChanged(true),
                    child: Row(
                      children: [
                        Text(
                          'Friends',
                          style: TextStyle(
                            color: showFriends ? Colors.white : Colors.grey,
                            fontSize: secondarySize,
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 40,
                          height: 22,
                          child: Stack(
                            children: friendProfiles.isEmpty
                                ? [
                                    const Positioned(
                                      left: 0,
                                      child: CircleAvatar(radius: 10),
                                    ),
                                    const Positioned(
                                      left: 12,
                                      child: CircleAvatar(radius: 10),
                                    ),
                                  ]
                                : List.generate(friendProfiles.length, (index) {
                                    return Positioned(
                                      left: index * 12.0,
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundImage: AssetImage(
                                          friendProfiles[index],
                                        ),
                                      ),
                                    );
                                  }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
