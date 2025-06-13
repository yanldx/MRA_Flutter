import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/rover_page.dart';

void main() {
  runApp(MarsRoverApp());
}

class MarsRoverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Rover API',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/Spirit': (context) => RoverPage(roverName: 'Spirit'),
        '/Opportunity': (context) => RoverPage(roverName: 'Opportunity'),
        '/Curiosity': (context) => RoverPage(roverName: 'Curiosity'),
      },
    );
  }
}