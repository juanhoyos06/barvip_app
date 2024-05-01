import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/models/Barber.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'barbers';

class BarberController extends BaseController {
  BarberController() : super(collection);

  Future<String> saveBarber(Barber barber) async {
    return await saveData(barber.toMap());
  }

  Future<void> updateBarber(Barber barber, String id) async {
    await updateData(barber.toMap(), id);
  }
}
