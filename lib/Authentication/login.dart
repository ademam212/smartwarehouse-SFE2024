import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:sfeapp/Authentication/signup.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/SQLite/sqlite.dart';
import 'package:sfeapp/page1.dart';
import 'package:sfeapp/pagecontroller.dart';
import 'package:sfeapp/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  login() async {
    var userExists = await db.userExists(email.text);
    if (userExists) {
      var result = await db.login(Users(
          usrName: "", usrEmail: email.text, usrPassword: password.text));
      if (result) {
        debugPrint("Login successful");
        var userName = await db.getUserNameByEmail(email.text);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Login successful",
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(user: Users(usrName: userName ?? "", usrEmail: email.text, usrPassword: password.text)),
          ),
        );
      } else {
        debugPrint("Login failed: incorrect password");
        setState(() {
          isLoginTrue = true;
        });
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Incorrect password",
          ),
        );
      }
    } else {
      debugPrint("Login failed: user not found");
      setState(() {
        isLoginTrue = true;
      });
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "User not found",
        ),
      );
    }
  }

  // Fonction pour valider l'email avec une expression régulière
  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Fonction pour valider la longueur du mot de passe
  bool validatePassword(String password) {
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
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
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset('images/login2.png', width: 300)
                          .animate()
                          .fadeIn(duration: 1000.ms),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(0.2),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!validateEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(0.2),
                        ),
                        child: TextFormField(
                          controller: password,
                          obscureText: !isVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            } else if (!validatePassword(value)) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password_rounded),
                            border: InputBorder.none,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(
                                  isVisible ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple,
                        ),
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                            },
                            child: const Text('SIGN UP'),
                          ),
                        ],
                      ),
                      isLoginTrue
                          ? const Text("Email or password incorrect", style: TextStyle(color: Colors.red))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
