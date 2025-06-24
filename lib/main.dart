import 'package:flutter/material.dart';
import './widgets/template_page.dart';
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
        '/Spirit': (context) => Template(
          title: 'Spirit',
          body: RoverPage(roverName: 'Spirit'),
        ),
        '/Opportunity': (context) => Template(
          title: 'Opportunity',
          body: RoverPage(roverName: 'Opportunity'),
        ),
        '/Curiosity': (context) => Template(
          title: 'Curiosity',
          body: RoverPage(roverName: 'Curiosity'),
        ),
      },

      home: RoverPage(roverName: 'Spirit'), // fallback si needed
    );
  }
}
