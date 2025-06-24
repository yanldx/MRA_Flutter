import 'package:flutter/material.dart';
import '../widgets/menu_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mars Rover API'),
      ),
      drawer: Menu(),
      body: Center(
        child: Text('Bienvenue sur l\'application Mars Rover'),
      ),
    );
  }
}