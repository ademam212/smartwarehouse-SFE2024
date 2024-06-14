import 'package:flutter/material.dart';
import 'package:sfeapp/Authentication/login.dart';

class Product {
  final String imageUrl;
  final String name;
  final String description;

  Product({
    required this.imageUrl,
    required this.name,
    required this.description,
  });
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      imageUrl: 'assets/images/rf.png',
      name: 'RFID Reader',
      description: 'This is an RFID Reader used for scanning tags.',
      
    ),
    Product(
      imageUrl: 'assets/images/T.png',
      name: 'RFID Tag',
      description: 'This is an RFID Tag that can be attached to items.',
      
    ),
    Product(
      imageUrl: 'assets/images/ann.png',
      name: 'RFID Antenna',
      description: 'This is an RFID Antenna for extended range.',
    ),
  ];
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Center(
              child: Text(
                'RFID Products',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _logout(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    product.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


