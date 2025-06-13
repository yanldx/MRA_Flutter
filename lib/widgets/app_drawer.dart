import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List<String> rovers = ['Spirit', 'Opportunity', 'Curiosity'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.red[50], // Couleur uniforme très claire sur tout le menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
              color: Colors.red[50], // même couleur que le drawer
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/fusee.png', width: 60, height: 60),
                  SizedBox(height: 10),
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
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/$rover');
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}