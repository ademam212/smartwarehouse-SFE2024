import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/Authentication/signup.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; // Récupère la hauteur de l'écran
    var width = MediaQuery.of(context).size.width; // Récupère la largeur de l'écran

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Container(
            padding: const EdgeInsets.all(20.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                Image.asset('images/wms.png', height: height * 0.5, fit: BoxFit.contain)
                  .animate(),
                   // Animation de fondu pour l'image
                Column(
                  children: [
                    const Text(
                      "Warehouse Management System",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms).slideX(duration: 700.ms, curve: Curves.easeInCubic),
                    const SizedBox(height: 10), 
                    const Text(
                      "Welcome to your Warehouse Management System. Let's get started!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 700.ms).slideX(duration: 900.ms, curve: Curves.easeInCubic),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

                        },
                        child: const Text("LOGIN"),
                        style: OutlinedButton.styleFrom(
                          
                          foregroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), 
                          ),
                          side: const BorderSide(color: Colors.black, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideX(duration: 1000.ms, curve: Curves.easeInCubic),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));

                        },
                        child: const Text("SIGN UP"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), 
                          ),
                          side: const BorderSide(color: Colors.black, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ).animate().fadeIn(duration: 900.ms).slideX(duration: 1100.ms, curve: Curves.easeInCubic),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}