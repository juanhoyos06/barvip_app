import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteController {
  final collection = 'favorites';
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addFavorite(data) async {
    print("objectjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
    final Map<String, dynamic> existFavorite =
        await getUserByIdBarber(data['idBarber']);

    if (existFavorite['success'] == false) {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection(collection).add(data);
      String id = docRef.id; // Add the document ID to data
      docRef.update({'id': id});
      return id;
    } else {
      return "";
    }
  }

  void deleteFavorite(String docId) async {
    await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
  }

  Future<Map<String, dynamic>> getUserByIdBarber(String emailBarber) async {
    QuerySnapshot querySnapshot = await db
        .collection(collection)
        .where('idBarber', isEqualTo: emailBarber)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return {'success': true, 'status': 200};
    } else {
      return {'success': false, 'status': 404};
    }
  }

  Future<String?> logicAddFavorite(
      bool isHeartSelected, String? favoriteId, data) async {
    print("ENTREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
    print(isHeartSelected);
    if (isHeartSelected) {
      favoriteId = await addFavorite(data);
    } else {
      if (favoriteId != null) {
        deleteFavorite(favoriteId);
        favoriteId = null; // Reset favoriteId after deleting the favorite
      }
    }
    return favoriteId;
  }

  Future<List<dynamic>> getFavorites(String idClient) async {
    var querySnapshot = await db
        .collection(collection)
        .where('idClient', isEqualTo: idClient)
        .get();

    return querySnapshot.docs.map((doc) => doc["idBarber"]).toList();
  }
}
