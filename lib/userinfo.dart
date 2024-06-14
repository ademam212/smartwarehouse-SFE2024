import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left : 24, bottom: 16),
        ),
        ListTile(
          
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Icon(CupertinoIcons.person, color: Colors.white,)
          ),
          title: Text("User information", style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}