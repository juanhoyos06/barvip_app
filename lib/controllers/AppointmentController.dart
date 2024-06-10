import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/utils/MyStyles.dart';
import 'package:barvip_app/models/Appointment.dart';
import 'package:barvip_app/models/User.dart';
import 'package:barvip_app/views/pages/BarberPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'appointment';
MyStyles myStyles = MyStyles();

class AppointmentController {
  createAppointment(
    GlobalKey<FormState> _key,
    TextEditingController addressController,
    TextEditingController dateController,
    TextEditingController hourController,
    Map<String, dynamic> services,
    TextEditingController priceController,
    TextEditingController suggestionController,
    UserProvider userProvider,
    String idBarber,
  ) async {
    try {
      if (validationAppointment(_key)) {
        Appointment newAppointment = Appointment(
          address: addressController.text,
          date: dateController.text,
          hour: hourController.text,
          services: services,
          price: double.parse(priceController.text),
          suggestion: suggestionController.text,
          idClient: userProvider.users['id'],
          idBarber: idBarber,
        );
        if (await existingAppointmentValidation(newAppointment)) {
          DocumentReference docRef =
              await db.collection(collection).add(newAppointment.toJson());
          await docRef.update({'id': docRef.id});
          return {"success": true, "state": 200, "operation": "create"};
        } else {
          return {"success": false, "state": 409};
        }
      }
      return {"success": false, "state": 500, "operation": "InvalidFields"};
    } catch (e) {
      return {"success": false, "state": 500, "operation": "error"};
    }
  }

  deleteAppointment(String id) {
    try {
      db.collection(collection).doc(id).delete();
      return {"success": true, "state": 200, "operation": "delete"};
    } catch (e) {
      return {"success": false, "state": 500, "operation": "error"};
    }
  }

  updateAppointment(
    GlobalKey<FormState> _key,
    TextEditingController addressController,
    TextEditingController dateController,
    TextEditingController hourController,
    Map<String, dynamic> services,
    TextEditingController priceController,
    TextEditingController suggestionController,
    Map<String, dynamic> oldAppointment,
    String idAppointment,
  ) async {
    try {
      if (validationAppointment(_key)) {
        Appointment newAppointment = Appointment(
          address: addressController.text,
          date: dateController.text,
          hour: hourController.text,
          services: services,
          price: double.parse(priceController.text),
          suggestion: suggestionController.text,
          idClient: oldAppointment['idClient'],
          idBarber: oldAppointment['idBarber'],
        );
        if (await existingAppointmentValidation(newAppointment)) {
          await db
              .collection(collection)
              .doc(idAppointment)
              .update(newAppointment.toJson());
          return {"success": true, "state": 200, "operation": "update"};
        } else {
          return {"success": false, "state": 410};
        }
      }
      return {"success": false, "state": 500, "operation": "InvalidFields"};
    } catch (e) {
      return {"success": false, "state": 500, "operation": "error"};
    }
  }

  validationAppointment(GlobalKey<FormState> _key) {
    if (_key.currentState!.validate()) {
      return true;
    }
    return false;
  }

  String? validationField(value) {
    return value == null || value.isEmpty ? "This field is required" : null;
  }

  String? validationHour(value, TimeOfDay? time) {
    validationField(value);
    if (value.length < 5 ||
        value.length > 8 ||
        time!.hour < 8 ||
        time.hour > 20) {
      return "Invalid hour";
    }
  }

  String? validatePice(value) {
    if (value == "0.0" || value.length == 0) return "Select a service";
  }

  Future<bool> existingAppointmentValidation(Appointment newAppointment) async {
    List<Appointment> appointments = await getAppointments();
    for (var appointment in appointments) {
      if (appointment.idBarber == newAppointment.idBarber &&
          appointment.date == newAppointment.date) {
        if (appointment.id == newAppointment.id) {
          return true;
        } else {
          double newHour = double.parse(newAppointment.hour.split(":")[0]);
          double newMinute =
              double.parse(newAppointment.hour.split(":")[1].split(" ")[0]);
          newMinute = newMinute * 0.01;
          double hour = double.parse(appointment.hour.split(":")[0]);
          double minute =
              double.parse(appointment.hour.split(":")[1].split(" ")[0]);
          minute = minute * 0.01;
          if (newHour + newMinute >= hour + minute &&
              newHour + newMinute <= hour + minute + 2) {
            return false;
          }
        }
      }
    }
    return true;
  }

  Future<List<Appointment>> getAppointments() async {
    QuerySnapshot querySnapshot2 = await db.collection(collection).get();
    List<DocumentSnapshot> appointmentsFirebase = querySnapshot2.docs;

    List<Appointment> appointments = appointmentsFirebase.map((doc) {
      return Appointment(
        id: doc['id'],
        idBarber: doc['idBarber'],
        idClient: doc['idClient'],
        date: doc['date'],
        hour: doc['hour'],
        services: doc['service'],
        address: doc['address'],
        price: doc['price'],
        suggestion: doc['suggestion'],
      );
    }).toList();

    return appointments;
  }

  Stream<QuerySnapshot> appoinmentWihtFilter(userProvider) {
    return db
        .collection(collection)
        .where(
            userProvider.users['typeUser'] == 'client'
                ? 'idClient'
                : 'idBarber',
            isEqualTo: userProvider.users['id'])
        .snapshots();
  }

  answers(response, context) {
    if (response['success'] == true && response['operation'] == 'delete') {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Congratulation!, you appointment is deleted", Colors.green),
      );
      Navigator.of(context).pop();
    }
    if (response['success'] == true && response['operation'] == 'create') {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Congratulations, your appointment was created successfully ",
            Colors.green),
      );
      Navigator.of(context).pop();
    }
    if (response['success'] == true && response['operation'] == 'update') {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Congratulations, your appointment was updated successfully ",
            Colors.green),
      );
      Navigator.of(context).pop();
    }
    if (response['success'] == false && response['state'] == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Error in creating your appointment", Colors.red),
      );
    }
    if (response['success'] == false && response['state'] == 410) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Failed to update your appointment", Colors.red),
      );
    }
    if (response['success'] == false &&
        response['state'] == 500 &&
        response['operation'] == 'InvalidFields') {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Invalid fields", Colors.red),
      );
    }
    if (response['success'] == false &&
        response['state'] == 500 &&
        response['operation'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Error", Colors.red),
      );
    }
  }

  SnackBar snackbarRegister(labelText, Color backgroundColor) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        labelText,
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
      duration: Duration(seconds: 2),
    );
  }
}
