import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/insta_widget.dart' as wid;
import '../widgets/image_posts.dart';

class HomePageFrame extends StatefulWidget {
  const HomePageFrame({super.key});

  @override
  State<HomePageFrame> createState() => HhomePgaeFrameState();
}

class HhomePgaeFrameState extends State<HomePageFrame> {
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

  Future<void> _onRefresh() async {
    // Replace with real data fetch when ready
    await Future.delayed(const Duration(seconds: 1));
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
              itemCount: dummyPosts.length,
              itemBuilder: (context, index) {
                final post = dummyPosts[index];
                final images =
                    (post['postImages'] as List?)?.cast<String>() ?? <String>[];

                return InstaPost(
                  username: post['username']?.toString() ?? '',
                  profileImage: post['profileImage']?.toString() ?? '',
                  postImages: images,
                  caption: post['caption']?.toString() ?? '',
                  likes: (post['likes'] as num?)?.toInt() ?? 0,
                  postType: _postTypeFromValue(post['postType']),
                  subLabel: post['subLabel']?.toString(),
                  ctaText: post['ctaText']?.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
