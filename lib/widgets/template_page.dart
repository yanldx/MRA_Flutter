import 'package:flutter/material.dart';
import 'app_drawer.dart';  // ton drawer

class Template extends StatelessWidget {
  final Widget body;
  final String title;

  const Template({Key? key, required this.body, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mars Rover Photos'),
      ),
      drawer: AppDrawer(),
      body: body,
    );
  }
}
