import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

enum StoryType { normal, live, closeFriend, premium }

const String _newStoryRingAsset = 'assets/icons/Insta/new_story_badge.svg';
const String _liveBadgeAsset = 'assets/icons/Insta/Live_badge.svg';
const String _premiumBadgeAsset = 'assets/icons/Insta/premium_badge.svg';
const double _sectionHeight = 118;
const double _ringSize = 98;
const double _ringToImageGap = 7;
const double _avatarSize = _ringSize - (_ringToImageGap * 2);
const double _avatarRadius = _avatarSize / 2;
const double _itemSpacing = 12;
const double _usernameWidth = 96;
const double _ringStrokeWidth = 3.5;
const double _liveBadgeHeight = 20;
const double _storyBadgeHeight = 24;
const double _storyBadgeBottomOffset = 0;
const double _ownStoryAddSize = 30;
const double _ownStoryAddIconSize = 16;
const double _ownStoryAddBorderWidth = 3;
const double _ownStoryAddBottomOffset = 1;
const double _ownStoryAddRightOffset = -1;
const double _storyToUsernameSpacing = 0;

Widget storiesSection(
  BuildContext context, {
  required List<Map<String, dynamic>> stories,
  ValueChanged<Map<String, dynamic>>? onStoryTap,
}) {
  return SizedBox(
    height: _sectionHeight,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final String username = story['username']?.toString() ?? '';
        final String imagePath = story['imagePath']?.toString() ?? '';
        final StoryType storyType = _storyTypeFromValue(story['storyType']);
        final bool isSeen = story['isSeen'] == true;
        final bool isOwnStory = story['isOwnStory'] == true;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _itemSpacing / 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(_ringSize),
              onTap: () {
                if (onStoryTap != null) {
                  onStoryTap(story);
                }
              },
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// STORY BORDER
                      _storyRing(storyType: storyType, isSeen: isSeen),

                      CircleAvatar(
                        radius: _avatarRadius,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: _storyAvatarImage(context, imagePath),
                        ),
                      ),

                      /// OWN STORY ADD ICON
                      if (isOwnStory)
                        Positioned(
                          bottom: _ownStoryAddBottomOffset,
                          right: _ownStoryAddRightOffset,
                          child: Container(
                            width: _ownStoryAddSize,
                            height: _ownStoryAddSize,
                            decoration: BoxDecoration(
                              color: InstaColors.storyOwnAddButton,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                width: _ownStoryAddBorderWidth,
                              ),
                            ),
                            // child: const Icon(
                            //   Icons.add,
                            //   size: _ownStoryAddIconSize,
                            //   color: Colors.white,
                            // ),
                            child: Center(
                              child: SizedBox(
                                width: _ownStoryAddIconSize * 0.75,
                                height: _ownStoryAddIconSize * 0.75,
                                child: SvgPicture.asset(
                                  'assets/icons/24x/plus.svg',
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      /// STORY TYPE BADGE
                      if (storyType == StoryType.live ||
                          storyType == StoryType.premium)
                        Positioned(
                          bottom: _storyBadgeBottomOffset,
                          child: _storyBadge(storyType),
                        ),
                    ],
                  ),

                  const SizedBox(height: _storyToUsernameSpacing),

                  /// USERNAME
                  SizedBox(
                    width: _usernameWidth,
                    child: Text(
                      username,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _storyAvatarImage(BuildContext context, String imagePath) {
  final placeholder = Container(
    width: _avatarSize,
    height: _avatarSize,
    color: Theme.of(context).dividerColor,
  );

  if (imagePath.toLowerCase().endsWith('.svg')) {
    return SvgPicture.asset(
      imagePath,
      width: _avatarSize,
      height: _avatarSize,
      fit: BoxFit.cover,
      placeholderBuilder: (context) => placeholder,
    );
  }

  return Image.asset(
    imagePath,
    width: _avatarSize,
    height: _avatarSize,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => placeholder,
  );
}

StoryType _storyTypeFromValue(dynamic rawType) {
  switch (rawType?.toString()) {
    case 'live':
      return StoryType.live;
    case 'closeFriend':
      return StoryType.closeFriend;
    case 'premium':
      return StoryType.premium;
    case 'normal':
    default:
      return StoryType.normal;
  }
}

/// Story badge widget
Widget _storyBadge(StoryType type) {
  switch (type) {
    case StoryType.live:
      return SvgPicture.asset(_liveBadgeAsset, height: _liveBadgeHeight);

    case StoryType.premium:
      return SvgPicture.asset(_premiumBadgeAsset, height: _storyBadgeHeight);

    default:
      return const SizedBox();
  }
}

Widget _storyRing({required StoryType storyType, required bool isSeen}) {
  if (isSeen) {
    return Container(
      width: _ringSize,
      height: _ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: InstaColors.storySeenRing,
          width: _ringStrokeWidth,
        ),
      ),
    );
  }

  if (storyType == StoryType.closeFriend) {
    return Container(
      width: _ringSize,
      height: _ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: InstaColors.storyCloseFriendRing,
          width: _ringStrokeWidth,
        ),
      ),
    );
  }

  if (storyType == StoryType.premium) {
    return Container(
      width: _ringSize,
      height: _ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: InstaColors.storyPremiumRing,
          width: _ringStrokeWidth,
        ),
      ),
    );
  }

  return SvgPicture.asset(
    _newStoryRingAsset,
    width: _ringSize,
    height: _ringSize,
  );
}

// Dropdown menu homepage

void showInstaDropdown(BuildContext context) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final double menuWidth = 180;

  await showMenu(
    context: context,
    color: Theme.of(context).colorScheme.surface,
    position: RelativeRect.fromLTRB(
      (overlay.size.width - menuWidth) / 2,
      kToolbarHeight + 30,
      (overlay.size.width - menuWidth) / 2,
      0,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    elevation: 6,
    items: [
      const PopupMenuItem(
        value: "following",
        child: Row(
          children: [
            Icon(Icons.people_outline),
            SizedBox(width: 12),
            Text("Following"),
          ],
        ),
      ),
      const PopupMenuItem(
        value: "favorites",
        child: Row(
          children: [
            Icon(Icons.star_border),
            SizedBox(width: 12),
            Text("Favorites"),
          ],
        ),
      ),
    ],
  );
}

void optionsPosts_drawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const _InstaPostMenu();
    },
  );
}

class _InstaPostMenu extends StatelessWidget {
  const _InstaPostMenu();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _TopAction(icon: Icons.bookmark_border, label: 'Save'),
                _TopAction(icon: Icons.loop, label: 'Remix'),
                _TopAction(icon: Icons.qr_code, label: 'QR code'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            indent: 12,
            endIndent: 12,
            color: Color.fromARGB(255, 226, 226, 226),
          ),
          _MenuItem(
            icon: Icons.star_border,
            text: 'Add to favorites',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.person_remove_outlined,
            text: 'Unfollow',
            onTap: () {},
          ),
          const Divider(
            indent: 12,
            endIndent: 12,
            color: Color.fromARGB(255, 226, 226, 226),
          ),
          _MenuItem(
            icon: Icons.closed_caption_outlined,
            text: 'Closed Captions',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.info_outline,
            text: "Why you're seeing this post",
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.visibility_off_outlined,
            text: 'Hide',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.person_outline,
            text: 'About this account',
            onTap: () {},
          ),
          _MenuItem(
            icon: Icons.report_outlined,
            text: 'Report',
            isDestructive: true,
            onTap: () {},
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _TopAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(icon),
            ),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? theme.colorScheme.error : theme.iconTheme.color,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isDestructive
              ? theme.colorScheme.error
              : theme.textTheme.bodyMedium?.color,
        ),
      ),
      onTap: onTap,
    );
  }
}
