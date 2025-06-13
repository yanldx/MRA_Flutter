import 'package:flutter/material.dart';

class RoverPage extends StatelessWidget {
  final String roverName;

  const RoverPage({required this.roverName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roverName)),
      body: Center(
        child: Text(
          roverName,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}