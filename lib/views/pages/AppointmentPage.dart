import 'package:barvip_app/controllers/AppointmentController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/views/pages/UpdateAppointment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppoinmentPage extends StatefulWidget {
  final Map<String, dynamic> appointment;

  AppoinmentPage({required this.appointment});

  @override
  State<AppoinmentPage> createState() => _AppoinmentPageState();
}

class _AppoinmentPageState extends State<AppoinmentPage> {
  final AppointmentController _appointmentController = AppointmentController();

  Map<String, dynamic> servicesPrices = {
    "Haircut": 150,
    "Beard": 100,
    "Eyebrows": 50,
    "Haircut and beard": 200,
    "Beard Design": 150,
    "Hair design": 150,
    "Hair & Beard Design": 250,
  };

  bool desicion = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("${widget.appointment['suggestion']} in appoinment page");
    return Consumer<UserProvider>(
      builder: (_, userProvider, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                  vertical: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(255, 28, 33, 39),
                      ),
                      child: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ))),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Text(
                      "Appointment Information",
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  ),
                  info(),
                  buttons(userProvider, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  info() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Date: ',
                    style: styleText(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.appointment['date'],
                    style: styleText(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Hour: ',
                    style: styleText(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.appointment['hour'],
                    style: styleText(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Address: ',
                    style: styleText(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.appointment['address'],
                    style: styleText(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Suggestion: ',
                    style: styleText(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.appointment['suggestion'],
                    style: styleText(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Total price: ',
                    style: styleText(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.appointment['price'].toString(),
                    style: styleText(),
                  ),
                ],
              ),
            ],
          ),
          Text("Services: ", style: styleText()),
          services(widget.appointment['service']),
        ],
      ),
    );
  }

  Widget services(Map<String, dynamic> value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          value.entries.where((entry) => entry.value == true).map((entry) {
        return Row(
          children: [
            Column(
              children: [
                Text(
                  '${entry.key}: ',
                  style: styleText(),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${servicesPrices[entry.key]}',
                  style: styleText(),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  buttons(UserProvider userProvider, context) {
    if (userProvider.users['typeUser'] == 'barber') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              bool result = await showConfirmationDialog(context);
              if (result) {
                final Map<String, dynamic> response = _appointmentController
                    .deleteAppointment(widget.appointment['id']);
                _appointmentController.answers(response, context);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              bool result = await showConfirmationDialog(context);
              if (result) {
                final Map<String, dynamic> response = _appointmentController
                    .deleteAppointment(widget.appointment['id']);
                _appointmentController.answers(response, context);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UpdateAppoinment(
                  appointment: widget.appointment,
                ),
              ));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 28, 33, 39)),
            ),
            icon: const Icon(
              Icons.edit,
              color: Color(0xFFD9AD26),
            ),
            label: const Text(
              'Reschedule',
              style: TextStyle(color: Color(0xFFD9AD26)),
            ),
          ),
        ],
      );
    }
  }

  TextStyle styleText() {
    return GoogleFonts.inter(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 0);
  }

  showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Confirmation',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w400,
                letterSpacing: 0),
          ),
          content: Text(
            'Are you sure of deleting your account?',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Cancel',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0)),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Dialog returns false
                  },
                ),
                TextButton(
                  child: Text('Accept',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0)),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Dialog returns true
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
