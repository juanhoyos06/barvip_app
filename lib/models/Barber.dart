import 'package:barvip_app/models/Client.dart';

class Barber extends Client {
  Barber(
      {required super.name,
      required super.lastName,
      required super.email,
      required super.password,
      required super.confirmPassword});

  Barber.empty() : super.empty();
}
