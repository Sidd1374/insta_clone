import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/insta_widget.dart' as wid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
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
      body: Column(
        children: [
          wid.storiesSection(
            context,
            stories: dummyStories,
            onStoryTap: (story) {
              final username = story['username']?.toString() ?? 'Story';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped $username')),
              );
            },
          ),
          const Expanded(child: Center(child: Text("Feed"))),
        ],
      ),
    );
  }
}
