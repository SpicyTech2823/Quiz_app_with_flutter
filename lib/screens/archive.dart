import 'package:flutter/material.dart';
class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Archive Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}