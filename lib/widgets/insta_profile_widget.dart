import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_clone/widgets/image_posts.dart';
import 'package:insta_clone/widgets/insta_reel_post.dart';

Widget profileSection(
  BuildContext context, {
  required Map<String, dynamic> profile,
}) {
  return _ProfileView(profile: profile);
}

class _ProfileView extends StatefulWidget {
  final Map<String, dynamic> profile;

  const _ProfileView({required this.profile});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  int selectedTab = 0;

  final List<IconData> tabs = const [
    Icons.grid_on,
    Icons.video_library_outlined,
    Icons.repeat,
    Icons.person_pin_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final tabPosts = (profile['posts'] as List?) ?? const [];
    final selectedPostsRaw =
        tabPosts.isNotEmpty && selectedTab < tabPosts.length
        ? tabPosts[selectedTab]
        : const [];
    final selectedPosts = _normalizeProfileItems(
      selectedPostsRaw as List,
      profile,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ProfileAppBar(profile: profile),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _ProfileHeader(profile: profile),
                    _ProfileBio(profile: profile),
                    if (profile['music'] != null)
                      _ProfileMusic(profile: profile),
                    _ProfessionalDashboard(profile: profile),
                    const SizedBox(height: 16),
                    _HighlightsSection(profile: profile),
                    _ProfileTabs(
                      tabs: tabs,
                      selectedTab: selectedTab,
                      onTap: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                    _ProfileGrid(
                      posts: selectedPosts,
                      onItemTap: (index) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => _ProfileFeedView(
                              items: selectedPosts,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _normalizeProfileItems(
    List rawItems,
    Map<String, dynamic> profile,
  ) {
    return rawItems.map<Map<String, dynamic>>((item) {
      if (item is String) {
        return {
          'type': 'image',
          'image': item,
          'username': profile['username']?.toString() ?? '',
          'profileImage': profile['profile']?.toString() ?? '',
          'caption': profile['bio']?.toString() ?? '',
          'likes': 0,
        };
      }

      if (item is Map<String, dynamic>) {
        final type = item['type']?.toString() ?? 'image';
        if (type == 'reel') {
          return {
            'type': 'reel',
            'video': item['video']?.toString() ?? 'assets/videos/reel_1.mp4',
            'thumbnail':
                item['thumbnail']?.toString() ??
                profile['profile']?.toString() ??
                '',
            'username':
                item['username']?.toString() ??
                profile['username']?.toString() ??
                '',
            'profileImage':
                item['profileImage']?.toString() ??
                profile['profile']?.toString() ??
                '',
            'caption': item['caption']?.toString() ?? '',
            'likes': (item['likes'] as num?)?.toInt() ?? 0,
            'comments': (item['comments'] as num?)?.toInt() ?? 0,
            'shares': (item['shares'] as num?)?.toInt() ?? 0,
          };
        }

        return {
          'type': 'image',
          'image':
              item['image']?.toString() ??
              item['asset']?.toString() ??
              profile['profile']?.toString() ??
              '',
          'username':
              item['username']?.toString() ??
              profile['username']?.toString() ??
              '',
          'profileImage':
              item['profileImage']?.toString() ??
              profile['profile']?.toString() ??
              '',
          'caption':
              item['caption']?.toString() ?? profile['bio']?.toString() ?? '',
          'likes': (item['likes'] as num?)?.toInt() ?? 0,
        };
      }

      return {
        'type': 'image',
        'image': profile['profile']?.toString() ?? '',
        'username': profile['username']?.toString() ?? '',
        'profileImage': profile['profile']?.toString() ?? '',
        'caption': profile['bio']?.toString() ?? '',
        'likes': 0,
      };
    }).toList();
  }
}

class _ProfileAppBar extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfileAppBar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconColor = Theme.of(context).iconTheme.color;
    const sideButtonWidth = 96.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: sideButtonWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.add, color: iconColor, size: 32),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile['username']?.toString() ?? '',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: iconColor),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: sideButtonWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.alternate_email, color: iconColor),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/24x/Menu.svg',
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      iconColor ?? Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfileHeader({required this.profile});

  Widget _stat(BuildContext context, String count, String label) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          count,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
        Text(label, style: textTheme.bodyMedium?.copyWith(color: onSurface)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: AssetImage(
                  profile['profile']?.toString() ?? '',
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile['name']?.toString() ?? '',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 40,
                  children: [
                    _stat(
                      context,
                      profile['friends']?.toString() ?? '0',
                      'friends',
                    ),
                    _stat(
                      context,
                      profile['followers']?.toString() ?? '0',
                      'followers',
                    ),
                    _stat(
                      context,
                      profile['following']?.toString() ?? '0',
                      'following',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBio extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfileBio({required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 2, 14, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((profile['profession'] as String?)?.isNotEmpty == true)
              Text(
                profile['profession']?.toString() ?? '',
                style: textTheme.bodyMedium,
              ),
            Text(
              profile['bio']?.toString() ?? '',
              style: textTheme.bodyMedium?.copyWith(color: onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMusic extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfileMusic({required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                profile['music']?.toString() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalDashboard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfessionalDashboard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final greyBackground = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade300;

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: greyBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Professional dashboard',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                profile['dashboard']?.toString() ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: greyBackground,
                    foregroundColor: colorScheme.onSurface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: greyBackground,
                    foregroundColor: colorScheme.onSurface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Share profile',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightsSection extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _HighlightsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final highlights = (profile['highlights'] as List?) ?? const [];
    final isOwnProfile = profile['isOwnProfile'] == true;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: highlights.length + (isOwnProfile ? 1 : 0),
        itemBuilder: (context, index) {
          if (isOwnProfile && index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: const Icon(Icons.add, size: 32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('New', style: textTheme.bodySmall),
                ],
              ),
            );
          }

          final dataIndex = isOwnProfile ? index - 1 : index;
          final item = highlights[dataIndex] as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundImage: AssetImage(item['image']?.toString() ?? ''),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title']?.toString() ?? '',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  final List<IconData> tabs;
  final int selectedTab;
  final ValueChanged<int> onTap;

  const _ProfileTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.onSurface;
    final unselectedColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Row(
      children: List.generate(
        tabs.length,
        (index) => Expanded(
          child: IconButton(
            icon: Icon(
              tabs[index],
              color: selectedTab == index ? selectedColor : unselectedColor,
            ),
            onPressed: () => onTap(index),
          ),
        ),
      ),
    );
  }
}

class _ProfileGrid extends StatelessWidget {
  final List posts;
  final ValueChanged<int>? onItemTap;

  const _ProfileGrid({required this.posts, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = posts[index] as Map<String, dynamic>;
        final isReel = item['type'] == 'reel';
        final imagePath = isReel
            ? item['thumbnail']?.toString() ?? ''
            : item['image']?.toString() ?? '';

        return GestureDetector(
          onTap: () => onItemTap?.call(index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              if (isReel)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white.withValues(alpha: 0.95),
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileFeedView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int initialIndex;

  const _ProfileFeedView({required this.items, required this.initialIndex});

  @override
  State<_ProfileFeedView> createState() => _ProfileFeedViewState();
}

class _ProfileFeedViewState extends State<_ProfileFeedView> {
  late final List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitial();
    });
  }

  void _scrollToInitial() {
    if (widget.initialIndex < 0 || widget.initialIndex >= _itemKeys.length) {
      return;
    }

    final targetContext = _itemKeys[widget.initialIndex].currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 1),
        alignment: 0.03,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return Container(
            key: _itemKeys[index],
            child: item['type'] == 'reel'
                ? InstaReelPost(
                    username: item['username']?.toString() ?? '',
                    profileImage: item['profileImage']?.toString() ?? '',
                    videoPath:
                        item['video']?.toString() ?? 'assets/videos/reel_1.mp4',
                    caption: item['caption']?.toString() ?? '',
                    likes: (item['likes'] as num?)?.toInt() ?? 0,
                    comments: (item['comments'] as num?)?.toInt() ?? 0,
                    shares: (item['shares'] as num?)?.toInt() ?? 0,
                    ctaText: null,
                    isAd: false,
                    showFollowButton: false,
                  )
                : InstaPost(
                    username: item['username']?.toString() ?? '',
                    profileImage: item['profileImage']?.toString() ?? '',
                    postImages: [item['image']?.toString() ?? ''],
                    caption: item['caption']?.toString() ?? '',
                    likes: (item['likes'] as num?)?.toInt() ?? 0,
                    postType: PostType.normal,
                    subLabel: null,
                    ctaText: null,
                    showFollowButton: false,
                  ),
          );
        },
      ),
    );
  }
}
