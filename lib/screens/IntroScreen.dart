import 'package:flutter/material.dart';


class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntroScreen'),
      ),
      body: const Center(
        child: Text('This is the IntroScreen'),
      ),
    );
  }
}