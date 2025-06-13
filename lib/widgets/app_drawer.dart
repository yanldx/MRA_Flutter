import 'package:flutter/material.dart';
import 'template.dart';
import '../pages/rover_page.dart';

class AppDrawer extends StatelessWidget {
  final List<String> rovers = ['Spirit', 'Opportunity', 'Curiosity'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.red[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
              color: Colors.red[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/fusee.png', width: 80, height: 80),
                  Text(
                    'Mars Rover',
                    style: TextStyle(color: Colors.black87, fontSize: 24),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            ...rovers.map((rover) {
              return ListTile(
                title: Text(
                  rover,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context); // ferme le drawer

                  // Navigation vers une nouvelle page avec le template
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(
                        title: rover,
                        body: RoverPageContent(roverName: rover),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
