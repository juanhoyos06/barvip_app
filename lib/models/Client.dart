class Client {
  late String name;
  late String lastName;
  late String email;
  late String password;
  late String typeUser;
  late bool active;
  late String urlImage;
  late String id;

  Client(
      {required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      this.active = true,
      required this.typeUser,
      required this.urlImage,
      this.id = ""});

  Client.empty() {
    name = "";
    lastName = "";
    email = "";
    password = "";
    active = true;
  }

  Client.whitId(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      this.active = true,
      required this.typeUser,
      required this.urlImage});

  //De Json a Mapa
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'active': true,
      'typeUser': typeUser,
      'urlImage': urlImage
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'active': true,
      'typeUser': typeUser,
      'urlImage': urlImage
    };
  }

  // De Mapa a Json
  fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    active = json['active'];
    typeUser = json['typeUser'];
    urlImage = json['urlImage'];
  }
}
