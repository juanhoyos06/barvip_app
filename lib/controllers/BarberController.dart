import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/models/Barber.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'barbers';

class BarberController extends BaseController {
  BarberController() : super(collection);

  Future<Map<String, dynamic>> saveBarber(Barber barber) async {
    return await saveData(barber.toJson());
  }

  Future<void> updateBarber(Barber barber, String id) async {
    await updateData(barber.toJson(), id);
  }

  Stream<QuerySnapshot>? usersStream() {
    return FirebaseFirestore.instance.collection(collection).snapshots();
  }
}
