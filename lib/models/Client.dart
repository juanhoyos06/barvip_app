class Client {
  late String name;
  late String lastName;
  late String email;
  late String password;
  late String confirmPassword;
  late bool active;

  Client(
      {required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPassword,
      this.active = true});

  Client.empty() {
    name = "";
    lastName = "";
    email = "";
    password = "";
    confirmPassword = "";
    active = true;
  }

  toMap() {
    return {
      'name': name,
      'lasName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'active': true
    };
  }
}
