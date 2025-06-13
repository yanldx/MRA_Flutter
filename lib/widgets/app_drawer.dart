import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List<String> rovers = ['Spirit', 'Opportunity', 'Curiosity'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/fusee.png', width: 30, height: 30),
                SizedBox(height: 10),
                Text('Rover', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          ...rovers.map((rover) {
            return ListTile(
              title: Center(child: Text(rover)),
              onTap: () {
                Navigator.pop(context); // Ferme le menu
                Navigator.pushNamed(context, '/$rover'); // Redirige vers la page correspondante
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}