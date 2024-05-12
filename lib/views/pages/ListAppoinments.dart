import 'package:barvip_app/controllers/AppointmentController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Appointment.dart';
import 'package:barvip_app/views/widget/AppoinmentView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ListAppoinments extends StatefulWidget {
  @override
  State<ListAppoinments> createState() => _ListAppoinmentsState();
}

class _ListAppoinmentsState extends State<ListAppoinments> {
  final AppointmentController _appointmentController = AppointmentController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, userProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 80, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Appointments',
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 3, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Don't remember your dates? Don't worry, these are your scheduled appointments",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _appointmentController.appoinmentWihtFilter(userProvider),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      "You don't have appointments or agendas",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return AppoinmentView(
                        data: data,
                      );
                    },
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
