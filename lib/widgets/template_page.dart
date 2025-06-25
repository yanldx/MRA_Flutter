import 'package:flutter/material.dart';
import 'menu_page.dart';  // ton drawer

class Template extends StatelessWidget {
  final Widget body;
  final String title;

  const Template({Key? key, required this.body, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[100],
        title: Text("Mars Rover Photo"),
      ),
      drawer: Menu(),
      body: body,
    );
  }
}
