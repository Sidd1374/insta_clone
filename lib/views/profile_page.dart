import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/insta_profile_widget.dart';

class ProfilePageFrame extends StatefulWidget {
  const ProfilePageFrame({super.key});

  @override
  State<ProfilePageFrame> createState() => _ProfilePageFrameState();
}

class _ProfilePageFrameState extends State<ProfilePageFrame> {
  final Map<String, dynamic> dummyProfile = {
    'isOwnProfile': true,
    'username': '_ig__User_',
    'profile': 'assets/Images/u1.png',
    'name': 'Siddharth',
    'profession': 'Photographer',
    'bio': "Hello it's me",
    'friends': '317',
    'followers': '367',
    'following': '571',
    'music': 'Harleys In Hawaii - Katy Perry',
    'dashboard': '11 views in the last 30 days.',
    'highlights': [
      {'title': 'Travel', 'image': 'assets/Images/u2.png'},
      {'title': 'Edits', 'image': 'assets/Images/u3.png'},
      {'title': 'Travel', 'image': 'assets/Images/u4.png'},
    ],
    'posts': [
      [
        'assets/Images/u5.png',
        {
          'type': 'reel',
          'video': 'assets/videos/reel_1.mp4',
          'thumbnail': 'assets/Images/u6.png',
          'caption': 'Quick reel preview from profile grid',
          'likes': 120,
          'comments': 12,
          'shares': 8,
        },
        'assets/Images/u7.png',
      ],
      ['assets/Images/u8.png', 'assets/Images/u9.png', 'assets/Images/u10.png'],
      [
        'assets/Images/u11.png',
        'assets/Images/u12.png',
        'assets/Images/u1.png',
      ],
      ['assets/Images/u2.png', 'assets/Images/u3.png', 'assets/Images/u4.png'],
    ],
  };

  @override
  Widget build(BuildContext context) {
    return profileSection(context, profile: dummyProfile);
  }
}
