import 'package:flutter/material.dart';
import 'container_frame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Insta_clone', home: ContainerFrame());
  }
}
