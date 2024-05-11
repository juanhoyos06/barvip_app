import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'appointment';

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
    if (validationAppointment(_key)) {
      Appointment newAppointment = Appointment(
        address: addressController.text,
        date: dateController.text,
        hour: hourController.text,
        services: services,
        price: double.parse(priceController.text),
        suggestion: suggestionController.text,
        idClient: userProvider.user['id'],
        idBarber: idBarber,
      );
      if (await existingAppointmentValidation(newAppointment)) {
        DocumentReference docRef =
            await db.collection(collection).add(newAppointment.toJson());
        await docRef.update({'id': docRef.id});
      } else {
        return "There is already an appointment at that time";
      }
    }
  }

  deleteAppointment() {}

  updateAppointment() {}

  validationAppointment(GlobalKey<FormState> _key) {
    if (_key.currentState!.validate()) {
      return true;
    }
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
}
