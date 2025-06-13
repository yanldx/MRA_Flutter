import 'package:flutter/material.dart';
import './widgets/template.dart';
import 'pages/rover_page.dart';

void main() {
  runApp(MarsRoverApp());
}

class MarsRoverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Rover API',
      initialRoute: '/Spirit', // ← par défaut sur Spirit
      routes: {
        '/Spirit': (context) => MainScaffold(
          title: 'Spirit',
          body: RoverPageContent(roverName: 'Spirit'),
        ),
        '/Opportunity': (context) => MainScaffold(
          title: 'Opportunity',
          body: RoverPageContent(roverName: 'Opportunity'),
        ),
        '/Curiosity': (context) => MainScaffold(
          title: 'Curiosity',
          body: RoverPageContent(roverName: 'Curiosity'),
        ),
      },

      home: RoverPageContent(roverName: 'Spirit'), // fallback si needed
    );
  }
}