import 'package:flutter/material.dart';

class InboxPageFrame extends StatefulWidget {
  const InboxPageFrame({super.key});

  @override
  State<InboxPageFrame> createState() => _InboxPageFrameState();
}

class _InboxPageFrameState extends State<InboxPageFrame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Inbox Page')));
  }
}
