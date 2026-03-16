import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/widgets/image_posts.dart';
import 'package:insta_clone/widgets/insta_reel_post.dart';
import 'dart:math';

class ExplorePageFrame extends StatefulWidget {
  const ExplorePageFrame({super.key});

  @override
  State<ExplorePageFrame> createState() => _ExplorePageFrameState();
}

class _ExplorePageFrameState extends State<ExplorePageFrame> {
  final List<Map<String, dynamic>> posts = [
    {'type': 'post', 'image': 'assets/Images/img1.jpg'},
    {'type': 'post', 'image': 'assets/Images/img2.jpg'},
    {
      'type': 'reel',
      'thumbnail': 'assets/Images/th1.jpg',
      'video': 'assets/videos/reel_1.mp4',
      'username': 'reels_user',
      'profileImage': 'assets/Images/u1.png',
      'caption': 'Explore reel',
      'likes': 432,
      'comments': 38,
      'shares': 12,
    },
    {'type': 'post', 'image': 'assets/Images/img3.jpg'},
    {'type': 'post', 'image': 'assets/Images/u7.png'},
    {'type': 'post', 'image': 'assets/Images/img4.jpg'},
    {'type': 'post', 'image': 'assets/Images/img5.jpg'},
    {
      'type': 'reel',
      'thumbnail': 'assets/Images/th2.jpg',
      'video': 'assets/videos/reel_1.mp4',
      'username': 'explore_reels',
      'profileImage': 'assets/Images/u2.png',
      'caption': 'Another reel',
      'likes': 892,
      'comments': 90,
      'shares': 26,
    },
    {'type': 'post', 'image': 'assets/Images/img6.jpg'},
    {'type': 'post', 'image': 'assets/Images/u8.png'},
    {'type': 'post', 'image': 'assets/Images/img7.jpg'},
    {'type': 'post', 'image': 'assets/Images/img8.jpg'},
    {'type': 'post', 'image': 'assets/Images/u9.png'},
    {'type': 'post', 'image': 'assets/Images/img9.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: exploreSection(context, posts: posts));
  }
}

/// EXPLORE SECTION WIDGETS
Widget exploreSection(
  BuildContext context, {
  required List<Map<String, dynamic>> posts,
}) {
  return _ExploreView(posts: posts);
}

class _ExploreView extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const _ExploreView({required this.posts});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// SEARCH BAR
          const _ExploreSearchBar(),

          /// GRID
          Expanded(child: _ExploreGrid(posts: posts)),
        ],
      ),
    );
  }
}

class _ExploreSearchBar extends StatefulWidget {
  const _ExploreSearchBar();

  @override
  State<_ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<_ExploreSearchBar> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardFillColor = isDarkMode
        ? Colors.grey.shade800.withOpacity(0.6)
        : Colors.grey.shade300;
    final searchBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          if (_isSearchFocused)
            IconButton(
              onPressed: () {
                _searchFocusNode.unfocus();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onTapOutside: (_) => _searchFocusNode.unfocus(),
              decoration: InputDecoration(
                hintText: 'Search with Meta AI',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icons/24x/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                filled: true,
                fillColor: cardFillColor,
                border: searchBorder,
                enabledBorder: searchBorder,
                focusedBorder: searchBorder,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const _ExploreGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(1.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
        childAspectRatio: 0.7,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final item = posts[index];
        final isReel = item['type'] == 'reel';
        final previewPath = isReel
            ? item['thumbnail']?.toString() ?? ''
            : item['image']?.toString() ?? '';

        return GestureDetector(
          onTap: () {
            if (isReel) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      _ExploreReelsView(items: posts, initialIndex: index),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      _ExploreFeedView(items: posts, initialIndex: index),
                ),
              );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Image.asset(previewPath, fit: BoxFit.cover),
              ),
              if (isReel)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      'assets/icons/24x/Reels.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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

class _ExploreFeedView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int initialIndex;

  const _ExploreFeedView({required this.items, required this.initialIndex});

  @override
  State<_ExploreFeedView> createState() => _ExploreFeedViewState();
}

class _ExploreFeedViewState extends State<_ExploreFeedView> {
  late final List<Map<String, dynamic>> randomizedItems;

  @override
  void initState() {
    super.initState();
    randomizedItems = _buildRandomizedFeed(
      widget.items,
      selectedIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Feed')),
      body: ListView.builder(
        itemCount: randomizedItems.length,
        itemBuilder: (context, index) {
          final item = randomizedItems[index];
          final isReel = item['type'] == 'reel';

          if (isReel) {
            return InstaReelPost(
              username: item['username']?.toString() ?? 'reels_user',
              profileImage:
                  item['profileImage']?.toString() ?? 'assets/Images/u1.png',
              videoPath:
                  item['video']?.toString() ?? 'assets/videos/reel_1.mp4',
              caption: item['caption']?.toString() ?? '',
              likes: (item['likes'] as num?)?.toInt() ?? 0,
              comments: (item['comments'] as num?)?.toInt() ?? 0,
              shares: (item['shares'] as num?)?.toInt() ?? 0,
            );
          }

          return InstaPost(
            username: item['username']?.toString() ?? 'explore_user',
            profileImage:
                item['profileImage']?.toString() ?? 'assets/Images/u1.png',
            postImages: [item['image']?.toString() ?? 'assets/Images/img1.jpg'],
            caption: item['caption']?.toString() ?? 'Explore post',
            likes: (item['likes'] as num?)?.toInt() ?? 0,
            postType: PostType.normal,
            subLabel: null,
            ctaText: null,
            showFollowButton: false,
          );
        },
      ),
    );
  }
}

class _ExploreReelsView extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int initialIndex;

  const _ExploreReelsView({required this.items, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final reelItems = items.where((item) => item['type'] == 'reel').toList();
    final selectedItem = items[initialIndex];
    final selectedVideo = selectedItem['video']?.toString();
    final initialReelIndex = reelItems.indexWhere(
      (item) => item['video']?.toString() == selectedVideo,
    );

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(
          initialPage: initialReelIndex < 0 ? 0 : initialReelIndex,
        ),
        itemCount: reelItems.length,
        itemBuilder: (context, index) {
          final item = reelItems[index];
          return InstaReelPost(
            username: item['username']?.toString() ?? 'reels_user',
            profileImage:
                item['profileImage']?.toString() ?? 'assets/Images/u1.png',
            videoPath: item['video']?.toString() ?? 'assets/videos/reel_1.mp4',
            caption: item['caption']?.toString() ?? '',
            likes: (item['likes'] as num?)?.toInt() ?? 0,
            comments: (item['comments'] as num?)?.toInt() ?? 0,
            shares: (item['shares'] as num?)?.toInt() ?? 0,
          );
        },
      ),
    );
  }
}

List<Map<String, dynamic>> _buildRandomizedFeed(
  List<Map<String, dynamic>> source, {
  required int selectedIndex,
}) {
  if (source.isEmpty || selectedIndex < 0 || selectedIndex >= source.length) {
    return source;
  }

  final selectedItem = source[selectedIndex];
  final remaining = [...source]..removeAt(selectedIndex);
  remaining.shuffle(Random());
  return [selectedItem, ...remaining];
}
