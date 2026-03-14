import 'package:flutter/material.dart';

class ProfilePageFrame extends StatefulWidget {
  const ProfilePageFrame({super.key});

  @override
  State<ProfilePageFrame> createState() => _ProfilePageFrameState();
}

class _ProfilePageFrameState extends State<ProfilePageFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Profile Page')));
  }
}
