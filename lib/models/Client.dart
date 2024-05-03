class Client {
  late String name;
  late String lastName;
  late String email;
  late String password;
  late String confirmPassword;
  late String typeUser;
  late bool active;

  Client(
      {required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPassword,
      this.active = true,
      required this.typeUser});

  Client.empty() {
    name = "";
    lastName = "";
    email = "";
    password = "";
    confirmPassword = "";
    active = true;
  }

  //De Json a Mapa
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lasName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'active': true,
      'typeUser': typeUser
    };
  }

  // De Mapa a Json
  fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    active = json['active'];
    typeUser = json['typeUser'];
  }
}
