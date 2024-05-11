import 'dart:ffi';

import 'package:barvip_app/controllers/AppointmentController.dart';
import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Appointment.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAppointmentPage extends StatefulWidget {
  final String idBarber;

  const CreateAppointmentPage({required this.idBarber});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppointmentController _appointmentControlelr = AppointmentController();

  double TotalPrice = 0;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();

  Map<String, dynamic> servicesPrices = {
    "Haircut": 150,
    "Beard": 100,
    "Eyebrows": 50,
    "Haircut and beard": 200,
    "Beard Design": 150,
    "Hair design": 150,
    "Hair & Beard Design": 250,
  };

  Map<String, dynamic> servicesButton = {
    "Haircut": false,
    "Beard": false,
    "Eyebrows": false,
    "Haircut and beard": false,
    "Beard Design": false,
    "Hair design": false,
    "Hair & Beard Design": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (_, userProvider, child) {
            return Container(
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Text(
                      'Schedule an appointment',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  ),
                  formAppointment(userProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Form formAppointment(UserProvider userProvider) => Form(
      key: _key,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelForms("Address"),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  controller: _addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: decoration("Enter an address"),
                  validator: (value) =>
                      _appointmentControlelr.validationField(value!),
                ),
                labelForms("Date"),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.datetime,
                  controller: _dateController,
                  onTap: selectDate,
                  decoration: decorationWhitIcon("Select a date",
                      const Icon(Icons.date_range), selectDate),
                  validator: (value) =>
                      _appointmentControlelr.validationField(value!),
                ),
                labelForms("Hour"),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.datetime,
                  controller: _hourController,
                  onTap: selectTime,
                  decoration: decorationWhitIcon("Select a hour",
                      const Icon(Icons.access_time), selectTime),
                  validator: (value) => _appointmentControlelr.validationHour(
                      value, selectedTime),
                ),
                labelForms("Select Service"),
                servicerCheckButtons(),
                labelForms("Total price"),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  enabled: false,
                  controller: _priceController,
                  validator: _appointmentControlelr.validatePice,
                  decoration: decoration("Selecte a service to calculate"),
                ),
                labelForms("Suggestion"),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  controller: _suggestionController,
                  decoration: decoration("Enter a suggestion"),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      child: scheduleAppointment(_key, userProvider)),
                )
              ],
            ),
          );
        },
      ));

  Padding labelForms(String labelText) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Text(
        labelText,
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }

  Column servicerCheckButtons() {
    return Column(
      children: [
        for (String service in servicesButton.keys)
          CheckboxListTile(
            title: Text(
              service,
              style: TextStyle(color: Colors.white),
            ),
            value: servicesButton[service],
            onChanged: (value) {
              servicesButton[service] = value;
              TotalPrice = servicesButton[service]
                  ? TotalPrice + servicesPrices[service]
                  : TotalPrice - servicesPrices[service];
              _priceController.text = TotalPrice.toString();
              setState(() {});
            },
            checkColor: const Color(0xFFD9AD26),
            activeColor: const Color.fromARGB(255, 255, 255, 255),
          ),
      ],
    );
  }

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: _dateController.text.isEmpty
            ? DateTime.now()
            : DateTime.parse(_dateController.text),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> selectTime() async {
    final _picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (_picked != null) {
      selectedTime = _picked;
      setState(() {
        _hourController.text = _picked.format(context);
      });
    }
  }

  ElevatedButton scheduleAppointment(_key, UserProvider userProvider) {
    return ElevatedButton(
      onPressed: () {
        _appointmentControlelr.createAppointment(
          _key,
          _addressController,
          _dateController,
          _hourController,
          servicesButton,
          _priceController,
          _suggestionController,
          userProvider,
          widget.idBarber,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD9AD26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Register',
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }

  InputDecoration decorationWhitIcon(
      String hintText, Icon icon, Function() funtion) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(108, 255, 255, 255)),
      fillColor: const Color.fromARGB(255, 28, 33, 39),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 28, 33, 39),
          width: 1,
        ),
      ),
      icon: IconButton(
        icon: icon,
        onPressed: funtion,
      ),
    );
  }

  InputDecoration decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(108, 255, 255, 255)),
      fillColor: const Color.fromARGB(255, 28, 33, 39),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 28, 33, 39),
          width: 1,
        ),
      ),
    );
  }
}
