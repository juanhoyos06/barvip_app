import 'package:barvip_app/models/Barber.dart';
import 'package:flutter/material.dart';

import '../models/Client.dart';

class UserProvider extends ChangeNotifier {
  late Map<String, dynamic> user;

  userFromClient(Client client) {
    user = client.toJsonWithId();
    notifyListeners();
  }

  userFromBarber(Barber barber) {
    user = barber.toJsonWithId();
    notifyListeners();
  }
}
