import 'package:flutter/material.dart';

class HomePageFrame extends StatefulWidget {
  const HomePageFrame({super.key});

  @override
  State<HomePageFrame> createState() => HhomePgaeFrameState();
}

class HhomePgaeFrameState extends State<HomePageFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Home Page')));
  }
}
