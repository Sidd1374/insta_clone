import 'package:flutter/material.dart';

class ReelPageFrame extends StatefulWidget {
  const ReelPageFrame({super.key});

  @override
  State<ReelPageFrame> createState() => _ReelPageFrameState();
}

class _ReelPageFrameState extends State<ReelPageFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Reel Page')));
  }
}
