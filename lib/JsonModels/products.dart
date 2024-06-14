class Products {
  int? productId; 
  String? epc;
  String productName;
  int qte;
  double price;  
  String fournisseur;
  String vendeur;

  Products({
    this.productId, 
    required this.epc,
    required this.productName, 
    required this.qte,
    required this.price,
    required this.fournisseur,
    required this.vendeur,
  });

  factory Products.fromMap(Map<String, dynamic> json) => Products(
    productId: json["productId"], // Changer usrId en productId
    epc: json["epc"],
    productName: json["productName"], 
    qte: json["qte"],
    price: json["price"].toDouble(), // Conversion en double
    fournisseur: json["fournisseur"],
    vendeur: json["vendeur"],
  );

  Map<String, dynamic> toMap() => {
    "productId": productId, // Changer usrId en productId
    "epc": epc,
    "productName": productName, 
    "qte": qte,
    "price": price,  // Conversion en double
    "fournisseur": fournisseur,
    "vendeur": vendeur,
  };
}
