import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/JsonModels/products.dart'; 

class DatabaseHelper {
  final databaseName = "user.db";

  String users = "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT, usrEmail TEXT UNIQUE, usrPassword TEXT)";
  
  String products = "create table products ("
      "productId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "epc TEXT UNIQUE, "
      "productName TEXT, "
      "qte INTEGER, "
      "price REAL, "
      "fournisseur TEXT, "
      "vendeur TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 14, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(products); 
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute("DROP TABLE IF EXISTS products");
      await db.execute(products);
    });
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }

  Future<bool> userExists(String usrEmail) async {
    final Database db = await initDB();
    var result = await db.rawQuery("SELECT * FROM users WHERE usrEmail = ?", [usrEmail]);
    return result.isNotEmpty;
  }

  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery("SELECT * FROM users WHERE usrEmail = ? AND usrPassword = ?", [user.usrEmail, user.usrPassword]);
    return result.isNotEmpty;
  }

  // Méthode pour récupérer le nom d'utilisateur par email
  Future<String?> getUserNameByEmail(String email) async {
    final db = await initDB();
    var result = await db.query(
      'users',
      columns: ['usrName'],
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['usrName'] as String?;
    } else {
      return null;
    }
  }

  // Méthode pour récupérer un utilisateur par email
  Future<Users?> getUserByEmail(String email) async {
    final db = await initDB();
    var result = await db.query(
      'users',
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return Users.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> updateUser(Users user) async {
    final Database db = await initDB();
    debugPrint('Updating user with ID: ${user.usrEmail}');
    debugPrint('New user data: $user');
    
    await db.update(
      'users',
      {
        'usrName': user.usrName,
        'usrEmail': user.usrEmail,
        'usrPassword': user.usrPassword,
      },
      where: 'usrEmail = ?',
      whereArgs: [user.usrEmail],
    );
  }

  Future<void> printAllUsers() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('users');
    if (maps.isEmpty) {
      debugPrint('No users found');
    } else {
      for (var map in maps) {
        debugPrint('User: ${Users.fromMap(map)}');
      }
    }
  }

  // Méthode pour insérer un produit
  Future<int> insertProduct(Products product) async {
    final Database db = await initDB();
    return await db.insert('products', product.toMap());
  }

  Future<bool> tableExists(String tableName) async {
    final db = await initDB();
    var result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  // Méthode pour récupérer tous les produits
  Future<List<Products>> getAllProducts() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Products.fromMap(maps[i]);
    });
  }

  // Méthode pour mettre à jour un produit
  Future<void> updateProduct(Products product) async {
    final Database db = await initDB();
    await db.update(
      'products',
      product.toMap(),
      where: 'productId = ?',
      whereArgs: [product.productId],
    );
  }

  // Méthode pour supprimer un produit
  Future<void> deleteProduct(int productId) async {
    final Database db = await initDB();
    await db.delete(
      'products',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> checkEPCExists(String epc) async {
    final Database db = await initDB();
    var result = await db.rawQuery("SELECT * FROM products WHERE epc = ?", [epc]);
    return result.isNotEmpty;
  }
}
