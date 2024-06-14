import 'package:flutter/material.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/page1.dart';
import 'package:sfeapp/profile_screen.dart';

class SideMenuTile extends StatelessWidget {
  final Users user;

  const SideMenuTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home_outlined, color: Colors.white),
      title: Text('Home', style: TextStyle(color: Colors.white)),
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

