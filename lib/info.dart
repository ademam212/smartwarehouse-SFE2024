import 'package:flutter/material.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/page1.dart';
import 'package:sfeapp/profile_screen.dart'; // Importez la classe ProfileScreen

class InfoMenu extends StatelessWidget {
  final String name;
  final String email;
  final Users user;

  const InfoMenu({
    required this.name,
    required this.email,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        email,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => App(user: user),
          ),
        );
      },
    );
  }
}
