import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/JsonModels/products.dart';
import 'package:sfeapp/SQLite/sqlite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Addproducts extends StatefulWidget {
  const Addproducts({Key? key}) : super(key: key);

  @override
  State<Addproducts> createState() => _AddproductsState();
}

class _AddproductsState extends State<Addproducts> {
  final _formKey = GlobalKey<FormState>();
  final epc = TextEditingController();
  final productName = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  final supplier = TextEditingController();
  final seller = TextEditingController();

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void resetForm() {
    epc.clear();
    productName.clear();
    quantity.clear();
    price.clear();
    supplier.clear();
    seller.clear();
    _formKey.currentState!.reset();
  }

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    checkProductsTable();
  }

  void checkProductsTable() async {
    bool exists = await dbHelper.tableExists('products');
    if (exists) {
      print('Table products exists.');
    } else {
      print('Table products does not exist.');
    }
  }

  void showTopAlert(BuildContext context, String message, CustomSnackBar customSnackBar) {
    final overlayState = Overlay.of(context);
    if (overlayState != null) {
      showTopSnackBar(
        overlayState,
        customSnackBar,
      );
    }
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
                'Add Products',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
      body: ListView(
        padding: const EdgeInsets.all(19),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('images/img.png'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: epc,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the epc';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'EPC',
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: productName,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Product Name',
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: quantity,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Quantity',
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: price,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: supplier,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name of the supplier';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Supplier',
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: seller,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name of the seller';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Seller',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (epc.text.isEmpty ||
                        productName.text.isEmpty ||
                        quantity.text.isEmpty ||
                        price.text.isEmpty ||
                        supplier.text.isEmpty ||
                        seller.text.isEmpty) {
                      showTopAlert(
                        context,
                        'Please fill in all fields!',
                        const CustomSnackBar.error(
                          message: 'Please fill in all fields!',
                        ),
                      );
                    } else {
                      if (_formKey.currentState!.validate()) {
                        bool tableExists = await dbHelper.tableExists('products');
                        if (tableExists) {
                          bool epcExists = await dbHelper.checkEPCExists(epc.text);
                          if (epcExists) {
                            showTopAlert(
                              context,
                              'EPC already exists!',
                              const CustomSnackBar.error(
                                message: 'EPC already exists!',
                              ),
                            );
                          } else {
                            Products newProduct = Products(
                              epc: epc.text,
                              productName: productName.text,
                              qte: int.parse(quantity.text),
                              price: double.parse(price.text),
                              fournisseur: supplier.text,
                              vendeur: seller.text,
                            );
                            await dbHelper.insertProduct(newProduct);
                            showTopAlert(
                              context,
                              'Product added successfully!',
                              const CustomSnackBar.success(
                                message: 'Product added successfully!',
                              ),
                            );
                            resetForm();
                          }
                        } else {
                          print('Table products does not exist. Please create it first.');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
