import 'package:barvip_app/models/Barber.dart';

class Barber {
  late String name;
  late String lastName;
  late String email;
  late String password;
  late String typeUser;
  late bool active;
  late String urlImage;
  late String id;

  Barber(
      {required super.name,
      required super.lastName,
      required super.email,
      required super.password,
      required super.typeUser,
      required super.urlImage,
      super.id});

  Barber.empty() : super.empty();
}
