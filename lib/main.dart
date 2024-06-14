import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/SQLite/sqlite.dart';
import 'package:sfeapp/addProducts.dart';
import 'package:sfeapp/pagecontroller.dart';
import 'package:sfeapp/products_rfid.dart';
import 'package:sfeapp/profile_screen.dart';
import 'package:sfeapp/rfid_details.dart';
import 'package:sfeapp/welcome.dart';
import 'package:sqflite/sqflite.dart';
void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkDatabase() async {
  final db = DatabaseHelper();
  await db.initDB();
  final path = await getDatabasesPath();
  final dbPath = join(path, db.databaseName);
  bool dbExists = await databaseExists(dbPath);
  if (dbExists) {
    debugPrint("Database exists");
    await db.printAllUsers(); // Appelle la méthode pour afficher les utilisateurs

    // Vérifier si la table des produits existe
    bool productsTableExists = await db.tableExists('products');
    if (productsTableExists) {
      debugPrint("Table products exists");
    } else {
      debugPrint("Table products does not exist");
    }
  } else {
    debugPrint("Database does not exist");
  }
  return dbExists;
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const Welcome(),
            //home : ProfileScreen(),
            //home: SideBar(),
            //home: ProductsRfid(),
            //home:Addproducts(),
            //home: ProductListScreen(),
            
          );
        }
      },
    );
  }
}
