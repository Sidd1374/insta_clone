import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/insta_widget.dart' as wid;
import '../widgets/image_posts.dart';
import '../widgets/insta_reel_post.dart';

enum _FeedItemType { post, reel }

class _FeedItem {
  final _FeedItemType type;
  final Map<String, dynamic> data;
  const _FeedItem(this.type, this.data);
}

class HomePageFrame extends StatefulWidget {
  const HomePageFrame({super.key});

  @override
  State<HomePageFrame> createState() => HhomePgaeFrameState();
}

class HhomePgaeFrameState extends State<HomePageFrame> {
  final Random _random = Random();
  List<_FeedItem> _feedItems = [];

  final List<Map<String, dynamic>> dummyStories = [
    {
      "username": "your_story",
      "imagePath": "assets/Images/u1.png",
      "storyType": "normal",
      "isSeen": false,
      "isOwnStory": true,
    },
    {
      "username": "john",
      "imagePath": "assets/Images/u2.png",
      "storyType": "live",
      "isSeen": false,
      "isOwnStory": false,
    },
    {
      "username": "emma",
      "imagePath": "assets/Images/u3.png",
      "storyType": "closeFriend",
      "isSeen": false,
      "isOwnStory": false,
    },
    {
      "username": "alex",
      "imagePath": "assets/Images/u4.png",
      "storyType": "premium",
      "isSeen": false,
      "isOwnStory": false,
    },
    {
      "username": "sarah",
      "imagePath": "assets/Images/u5.png",
      "storyType": "closeFriend",
      "isSeen": true,
      "isOwnStory": false,
    },
    {
      "username": "Joe",
      "imagePath": "assets/Images/u1.png",
      "storyType": "normal",
      "isSeen": true,
      "isOwnStory": false,
    },
    {
      "username": "zack",
      "imagePath": "assets/Images/u1.png",
      "storyType": "normal",
      "isSeen": true,
      "isOwnStory": false,
    },
  ];

  final List<Map<String, dynamic>> dummyPosts = [
    {
      'username': 'Ruffles',
      'profileImage': 'assets/Images/u1.png',
      'postImages': ['assets/Images/u12.png'],
      'caption': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      'likes': 100,
      'postType': 'sponsored',
      'subLabel': null,
      'ctaText': null,
      'showFollowButton': false,
    },
    {
      'username': 'NatureDaily',
      'profileImage': 'assets/Images/u2.png',
      'postImages': [
        'assets/Images/u2.png',
        'assets/Images/u3.png',
        'assets/Images/u4.png',
      ],
      'caption': 'Beautiful views from the mountains 🏔️',
      'likes': 320,
      'postType': 'normal',
      'subLabel': '📍 Swiss Alps',
      'ctaText': null,
      'showFollowButton': true,
    },
    {
      'username': 'MusicWorld',
      'profileImage': 'assets/Images/u3.png',
      'postImages': ['assets/Images/u5.png'],
      'caption': 'New track dropping tonight 🎵',
      'likes': 210,
      'postType': 'normal',
      'subLabel': '🎵 Original Audio',
      'ctaText': null,
      'showFollowButton': true,
    },
    {
      'username': 'Nike',
      'profileImage': 'assets/Images/u4.png',
      'postImages': ['assets/Images/u6.png', 'assets/Images/u7.png'],
      'caption': 'Run faster. Go further.',
      'likes': 540,
      'postType': 'ad',
      'subLabel': null,
      'ctaText': 'Shop Now',
      'showFollowButton': false,
    },
    {
      'username': 'TravelGram',
      'profileImage': 'assets/Images/u5.png',
      'postImages': ['assets/Images/u8.png'],
      'caption': 'Sunsets like this never get old 🌅',
      'likes': 188,
      'postType': 'normal',
      'subLabel': '📍 Bali',
      'ctaText': null,
      'showFollowButton': true,
    },
    {
      'username': 'Apple',
      'profileImage': 'assets/Images/u2.png',
      'postImages': [
        'assets/Images/u9.png',
        'assets/Images/u10.png',
        'assets/Images/u11.png',
      ],
      'caption': 'Shot on iPhone 📸',
      'likes': 980,
      'postType': 'sponsored',
      'subLabel': null,
      'ctaText': null,
      'showFollowButton': false,
    },
  ];

  final List<Map<String, dynamic>> dummyReels = [
    {
      'username': 'thatcreditcardguy',
      'profileImage': 'assets/Images/u1.png',
      'videoPath': 'assets/videos/reel_1.mp4',
      'caption': 'The Daily Objects Stack has taken over',
      'likes': 10500,
      'comments': 97,
      'shares': 1920,
      'ctaText': 'Shop now',
      'isAd': true,
      'showFollowButton': false,
    },
    {
      'username': 'NatureDaily',
      'profileImage': 'assets/Images/u2.png',
      'videoPath': 'assets/videos/reel_1.mp4',
      'caption': 'Morning hike views straight from the Alps 🌄',
      'likes': 5200,
      'comments': 43,
      'shares': 312,
      'ctaText': null,
      'isAd': false,
      'showFollowButton': true,
    },
    {
      'username': 'MusicWorld',
      'profileImage': 'assets/Images/u3.png',
      'videoPath': 'assets/videos/reel_1.mp4',
      'caption': 'New beat drop incoming 🎵🔥',
      'likes': 8800,
      'comments': 120,
      'shares': 670,
      'ctaText': null,
      'isAd': false,
      'showFollowButton': true,
    },
  ];

  PostType _postTypeFromValue(dynamic rawType) {
    switch (rawType?.toString()) {
      case 'sponsored':
        return PostType.sponsored;
      case 'ad':
        return PostType.ad;
      case 'normal':
      default:
        return PostType.normal;
    }
  }

  @override
  void initState() {
    super.initState();
    _feedItems = _buildFeedItems();
  }

  /// Mixes posts and reels: pattern [1 post, 1 reel, 2 posts] repeating.
  /// Add -2 to the pattern for suggestion slots later.
  List<_FeedItem> _buildFeedItems() {
    final posts = List<Map<String, dynamic>>.from(dummyPosts)..shuffle(_random);
    final reels = List<Map<String, dynamic>>.from(dummyReels)..shuffle(_random);

    final postItems = posts
        .map((p) => _FeedItem(_FeedItemType.post, p))
        .toList();
    final reelItems = reels
        .map((r) => _FeedItem(_FeedItemType.reel, r))
        .toList();

    // positive int = N posts consumed, -1 = 1 reel consumed
    const pattern = [1, -1, 2];
    int postIdx = 0, reelIdx = 0, pi = 0;
    final result = <_FeedItem>[];

    while (postIdx < postItems.length || reelIdx < reelItems.length) {
      final step = pattern[pi % pattern.length];
      if (step == -1) {
        if (reelIdx < reelItems.length) {
          result.add(reelItems[reelIdx++]);
        } else if (postIdx < postItems.length) {
          result.add(postItems[postIdx++]);
        }
      } else {
        for (int i = 0; i < step; i++) {
          if (postIdx < postItems.length) {
            result.add(postItems[postIdx++]);
          } else if (reelIdx < reelItems.length) {
            result.add(reelItems[reelIdx++]);
          }
        }
      }
      pi++;
    }

    return result;
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }
    setState(() {
      _feedItems = _buildFeedItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              centerTitle: true,
              floating: false,
              pinned: false,
              leading: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/24x/plus.svg', height: 26),
              ),
              title: GestureDetector(
                onTap: () {
                  wid.showInstaDropdown(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Insta/insta_text_logo.svg',
                      height: 32,
                    ),
                    const SizedBox(width: 4),
                    Transform.rotate(
                      angle: 3.1416,
                      child: SvgPicture.asset(
                        'assets/icons/24x/Chevron Up.svg',
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                SvgPicture.asset('assets/icons/24x/Like.svg', height: 28),
                const SizedBox(width: 10),
              ],
            ),
            SliverToBoxAdapter(
              child: wid.storiesSection(
                context,
                stories: dummyStories,
                onStoryTap: (story) {
                  final username = story['username']?.toString() ?? 'Story';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Tapped $username')));
                },
              ),
            ),
            SliverList.builder(
              itemCount: _feedItems.length,
              itemBuilder: (context, index) {
                final item = _feedItems[index];
                final data = item.data;

                if (item.type == _FeedItemType.reel) {
                  return InstaReelPost(
                    username: data['username']?.toString() ?? '',
                    profileImage: data['profileImage']?.toString() ?? '',
                    videoPath: data['videoPath']?.toString() ?? '',
                    caption: data['caption']?.toString() ?? '',
                    likes: (data['likes'] as num?)?.toInt() ?? 0,
                    comments: (data['comments'] as num?)?.toInt() ?? 0,
                    shares: (data['shares'] as num?)?.toInt() ?? 0,
                    ctaText: data['ctaText']?.toString(),
                    isAd: data['isAd'] == true,
                    showFollowButton: data['showFollowButton'] == true,
                  );
                }

                // default: image post
                final images =
                    (data['postImages'] as List?)?.cast<String>() ?? <String>[];
                return InstaPost(
                  username: data['username']?.toString() ?? '',
                  profileImage: data['profileImage']?.toString() ?? '',
                  postImages: images,
                  caption: data['caption']?.toString() ?? '',
                  likes: (data['likes'] as num?)?.toInt() ?? 0,
                  postType: _postTypeFromValue(data['postType']),
                  subLabel: data['subLabel']?.toString(),
                  ctaText: data['ctaText']?.toString(),
                  showFollowButton: data['showFollowButton'] == true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
