import 'package:barvip_app/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late Map<String, dynamic> users;
  Map<String, bool> hearts = {}; // Mapa para almacenar el estado de cada corazón
  bool filterFav= false;
  String? favoriteId = null;

  userFromDb(User user) {
    users = user.toJson();
    notifyListeners();
  }
  changeFavId(String? id){
    favoriteId = id;
    notifyListeners();
  }

  // Método para cambiar el estado de un corazón específico
  changeHeart(String id) {
    if (hearts[id] == null) {
      hearts[id] = true;
    } else {
      hearts[id] = !hearts[id]!;
    }
    notifyListeners();
  }

  // Método para obtener el estado de un corazón específico
  bool isHeartSelected(String id) {
    return hearts[id] ?? false;
  }

  filter() {
    filterFav = !filterFav;
    notifyListeners();
  }
}