import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/addProducts.dart';
import 'package:sfeapp/page1.dart';
import 'package:sfeapp/products_rfid.dart';
import 'package:sfeapp/profile_screen.dart';
import 'package:sfeapp/rfid_details.dart';

class MainScreen extends StatefulWidget {
  final Users user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  void _onNavBarTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          App(user: widget.user),
          ProductsRfid(),
          Addproducts(),
          ProductListScreen(),
          ProfileScreen(user: widget.user),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 200),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.dashboard_outlined, color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.production_quantity_limits_outlined, color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.add_circle_outlined, color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.nfc_rounded, color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_2_outlined, color: Colors.white),
          ),
        ],
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
