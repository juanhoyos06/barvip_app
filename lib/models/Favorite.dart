import 'package:barvip_app/models/User.dart';

class Favorite{
  final String idBarber;
  final String idClient;

  Favorite({required this.idClient, required this.idBarber});

   Map<String, dynamic> toJson() {
    return {
      'idBarber': idBarber,
      'idClient': idClient,
    };
  }

}