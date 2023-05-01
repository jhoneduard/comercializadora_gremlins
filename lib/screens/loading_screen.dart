import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final AppBar appBar;
  const LoadingScreen({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.indigo),
      ),
    );
  }
}
