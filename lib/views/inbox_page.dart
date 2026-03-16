import 'package:flutter/material.dart';
import '../widgets/insta_dm_widget.dart';

class InboxPageFrame extends StatefulWidget {
  const InboxPageFrame({super.key});

  @override
  State<InboxPageFrame> createState() => _InboxPageFrameState();
}

class _InboxPageFrameState extends State<InboxPageFrame> {
  final dummyUsers = [
    {
      "name": "Jhon Doe",
      "image": "assets/Images/u1.png",
      "status": "Seen 4h ago",
      "storyStatus": "new",
      "onCameraTap": () {},
    },
    {
      "name": "Billy Butcher",
      "image": "assets/Images/u2.png",
      "status": "Sent 6h ago",
      "storyStatus": "seen",
      "onCameraTap": () {},
    },
    {
      "name": "Walter White",
      "image": "assets/Images/u3.png",
      "status": "Sent 6h ago",
      "storyStatus": null,
      "onCameraTap": () {},
    },
    {
      "name": "James Bond",
      "image": "assets/Images/u1.png",
      "status": "Reacted 👍 to your message · 10h",
      "storyStatus": "seen",
      "onCameraTap": () {},
    },
    {
      "name": "BoB",
      "image": "assets/Images/u2.png",
      "status": "Sent 11h ago",
      "storyStatus": null,
      "onCameraTap": () {},
    },
    {
      "name": "Sarah",
      "image": "assets/Images/u3.png",
      "status": "Sent 12h ago",
      "storyStatus": "new",
      "onCameraTap": () {},
    },
  ];

  final dummyNotes = [
    {
      "name": "Your note",
      "image": "assets/Images/u1.png",
      "noteText": "What's new?",
      "isBadge": false,
    },
    {
      "name": "Billy Butcher",
      "image": "assets/Images/u2.png",
      "noteText": "Akhyian...",
      "isBadge": false,
    },
    {
      "name": "Walter White",
      "image": "assets/Images/u3.png",
      "noteText": "Its a Brand New day",
      "isBadge": false,
    },
    // {
    //   "name": "Map",
    //   "image": "assets/Images/u1.png",
    //   "noteText": "New",
    //   "isBadge": true,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: dmSection(context, users: dummyUsers, notes: dummyNotes),
      ),
    );
  }
}
