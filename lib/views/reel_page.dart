import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/reel_Section_widget.dart';

class ReelPageFrame extends StatefulWidget {
  const ReelPageFrame({super.key});

  @override
  State<ReelPageFrame> createState() => _ReelPageFrameState();
}

class _ReelPageFrameState extends State<ReelPageFrame> {
  final List<Map<String, dynamic>> dummyReels = [
    {
      'username': 'User1',
      'verified': true,
      'profile': 'assets/Images/u1.png',
      'video': 'assets/videos/reel_12.mp4',
      'caption':
          'reel_1 captions this is the reel that we have added to our project for testing ',
      'likes': '206K',
      'comments': '1,261',
      'shares': '1,627',
      'saves': '16.1K',
      'music': 'Original Audio',
    },
    {
      'username': 'NatureDaily',
      'verified': false,
      'profile': 'assets/Images/u2.png',
      'video': 'assets/videos/reel_1.mp4',
      'caption': 'Morning mountain air and quiet trails. #reels #nature',
      'likes': '82.4K',
      'comments': '842',
      'shares': '934',
      'saves': '4.8K',
      'music': 'Original Audio',
    },
    {
      'username': 'TravelGram',
      'verified': true,
      'profile': 'assets/Images/u5.png',
      'video': 'assets/videos/reel_1.mp4',
      'caption': 'Sunset run by the beach. Save this view for later.',
      'likes': '147K',
      'comments': '2,012',
      'shares': '3,403',
      'saves': '12.7K',
      'music': 'Original Audio',
    },
    {
      'username': 'User2',
      'verified': true,
      'profile': 'assets/Images/u2.png',
      'video': 'assets/videos/reel_1.mp4',
      'caption':
          'reel_1 captions this is the reel that we have added to our project for testing ',
      'likes': '206K',
      'comments': '1,261',
      'shares': '1,627',
      'saves': '16.1K',
      'music': 'Original Audio',
    },
    {
      'username': 'User3',
      'verified': true,
      'profile': 'assets/Images/u9.png',
      'video': 'assets/videos/reel_1.mp4',
      'caption':
          'reel_1 captions this is the reel that we have added to our project for testing ',
      'likes': '206K',
      'comments': '1,261',
      'shares': '1,627',
      'saves': '16.1K',
      'music': 'Original Audio',
    },
    {
      'username': 'User4',
      'verified': true,
      'profile': 'assets/Images/u9.png',
      'video': 'assets/videos/reel_1.mp4',
      'caption':
          'reel_1 captions this is the reel that we have added to our project for testing ',
      'likes': '206K',
      'comments': '1,261',
      'shares': '1,627',
      'saves': '16.1K',
      'music': 'Original Audio',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: reelsSection(context, reels: dummyReels));
  }
}
