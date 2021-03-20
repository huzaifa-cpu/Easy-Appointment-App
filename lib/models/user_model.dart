class User {
  User({
    this.id,
    this.type,
    this.landingUrl,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.username,
    this.password,
    this.avatar,
    this.state,
    this.status,
    this.createdDate,
    this.updatedDate,
//    this.role,
  });

  int id;
  String type;
  dynamic landingUrl;
  String fullName;
  dynamic email;
  String phone;
  dynamic gender;
  String username;
  String password;
  dynamic avatar;
  bool state;
  String status;
  String createdDate;
  dynamic updatedDate;

//  dynamic role;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        type: json["type"],
        landingUrl: json["landingUrl"],
        fullName: json["fullName"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        username: json["username"],
        password: json["password"],
        avatar: json["avatar"],
        state: json["state"],
        status: json["status"],
        createdDate: json["createdDate"],
        updatedDate: json["updatedDate"],
//        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "landingUrl": landingUrl,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "username": username,
        "password": password,
        "avatar": avatar,
        "state": state,
        "status": status,
        "createdDate": createdDate,
        "updatedDate": updatedDate,
//        "role": role ?? '',
      };
}
