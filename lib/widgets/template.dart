import 'package:flutter/material.dart';
import 'app_drawer.dart';  // ton drawer

class MainScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const MainScaffold({Key? key, required this.body, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppDrawer(),
      body: body,
    );
  }
}
