class Users {
   int? usrId;
  String usrName; 
   String usrEmail; 
   String usrPassword;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrEmail, 
    required this.usrPassword,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrEmail: json["usrEmail"], 
        usrPassword: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrEmail": usrEmail, 
        "usrPassword": usrPassword,
      };
}
