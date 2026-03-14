import 'package:flutter/material.dart';

class ExplorePageFrame extends StatefulWidget {
  const ExplorePageFrame({super.key});

  @override
  State<ExplorePageFrame> createState() => _ExplorePageFrameState();
}

class _ExplorePageFrameState extends State<ExplorePageFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Explore Page')));
  }
}
