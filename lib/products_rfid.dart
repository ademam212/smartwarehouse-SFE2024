import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/JsonModels/products.dart';
import 'package:sfeapp/SQLite/sqlite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProductsRfid extends StatefulWidget {
  const ProductsRfid({Key? key}) : super(key: key);

  @override
  State<ProductsRfid> createState() => _ProductsRfidState();
}

class _ProductsRfidState extends State<ProductsRfid> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Products> products = [];
  Products? editingProduct;
  final _formKey = GlobalKey<FormState>();
  final epcController = TextEditingController();
  final productNameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final supplierController = TextEditingController();
  final sellerController = TextEditingController();

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    List<Products> productList = await dbHelper.getAllProducts();
    setState(() {
      products = productList;
    });
  }

  void _confirmDeleteProduct(int id) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Are you sure?',
      text: 'Do you really want to delete this product?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the alert dialog
        _deleteProduct(id); // Call the delete method
      },
    );
  }

  void _deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);
    loadProducts(); // Reload products after deletion
  }

  void _editProduct(Products product) {
    setState(() {
      editingProduct = product;
      epcController.text = product.epc!;
      productNameController.text = product.productName;
      quantityController.text = product.qte.toString();
      priceController.text = product.price.toString();
      supplierController.text = product.fournisseur;
      sellerController.text = product.vendeur;
    });
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // Check if the updated EPC already exists
      if (await dbHelper.checkEPCExists(epcController.text) && epcController.text != editingProduct!.epc) {
          showTopAlert(
                              context,
                              'EPC already exists!',
                              const CustomSnackBar.error(
                                message: 'EPC already exists!',
                              ),
                            );
        return;
      }

      Products updatedProduct = Products(
        productId: editingProduct!.productId,
        epc: epcController.text,
        productName: productNameController.text,
        qte: int.parse(quantityController.text),
        price: double.parse(priceController.text),
        fournisseur: supplierController.text,
        vendeur: sellerController.text,
      );
      await dbHelper.updateProduct(updatedProduct);
      setState(() {
        editingProduct = null;
        epcController.clear();
        productNameController.clear();
        quantityController.clear();
        priceController.clear();
        supplierController.clear();
        sellerController.clear();
      });
      loadProducts(); // Reload products after update

      // Show success message
    showTopAlert(
                              context,
                              'Product updated successfully!',
                              const CustomSnackBar.success(
                                message: 'Product updated successfully!',
                              ),
                            );
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
                'Products',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
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
          return Column(
            children: [
              ProductBox(
                product: products[index],
                onDelete: () => _confirmDeleteProduct(products[index].productId!),
                onEdit: () => _editProduct(products[index]),
              ),
              if (editingProduct != null && editingProduct!.productId == products[index].productId)
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: epcController,
                          decoration: InputDecoration(labelText: 'EPC'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the EPC';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: productNameController,
                          decoration: InputDecoration(labelText: 'Product Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: quantityController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number, // Set to number input
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the quantity';
                            }
                            // Add additional validation if needed
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number, // Set to number input
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the price';
                            }
                            // Add additional validation if needed
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: supplierController,
                          decoration: InputDecoration(labelText: 'Supplier'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the supplier';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: sellerController,
                          decoration: InputDecoration(labelText: 'Seller'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the seller';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _updateProduct,
                              child: Text('Update'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  editingProduct = null;
                                  epcController.clear();
                                  productNameController.clear();
                                  quantityController.clear();
                                  priceController.clear();
                                  supplierController.clear();
                                  sellerController.clear();
                                });
                              },
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
  final Products product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductBox({
    Key? key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EPC: ${product.epc}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Product Name: ${product.productName}'),
            Text('Quantity: ${product.qte}'),
            Text('Price: ${product.price} DH'),
            Text('Supplier: ${product.fournisseur}'),
            Text('Seller: ${product.vendeur}'),
          ],
        ),
      ),
    );
  }
}
