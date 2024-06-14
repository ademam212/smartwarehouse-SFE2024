import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ProductMenu extends StatelessWidget {
  const ProductMenu({super.key});

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
            child: Icon(Icons.production_quantity_limits_outlined, color: Colors.white,)
          ),
          title: Text("Products", style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}