import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/views/pages/AppointmentPage.dart';
import 'package:barvip_app/views/pages/BarberPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppoinmentView extends StatefulWidget {
  final Map<String, dynamic> data;

  AppoinmentView({required this.data});

  @override
  State<AppoinmentView> createState() => _AppoinmentViewState();
}

class _AppoinmentViewState extends State<AppoinmentView> {
  final UserController _userController = UserController();

  Map<String, dynamic> data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 33, 39),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Date:',
                                    style: styleText(),
                                  ),
                                  Text(
                                    'Hour:',
                                    style: styleText(),
                                  ),
                                  Text(
                                    'Address:',
                                    style: styleText(),
                                  ),
                                  Text(
                                    'Price:'.toString(),
                                    style: styleText(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    widget.data['date'],
                                    style: styleText(),
                                  ),
                                  Text(
                                    widget.data['hour'],
                                    style: styleText(),
                                  ),
                                  Text(
                                    widget.data['address'],
                                    style: styleText(),
                                  ),
                                  Text(
                                    widget.data['price'].toString(),
                                    style: styleText(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        getButtons(userProvider),
                      ],
                    ),
                  ))),
        );
      },
    );
  }

  getButtons(UserProvider userProvider) {
    if (userProvider.users['typeUser'] == 'barber') {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                print(widget.data);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AppoinmentPage(appointment: widget.data),
                ));
              },
              child: Text(
                "View appointment",
                style: TextStyle(
                  color: Color(0xFFD9AD26),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> user =
                      await _userController.getUser(widget.data['idBarber']);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BarberPage(barber: user),
                  ));
                },
                child: Text(
                  "Info barber",
                  style: TextStyle(
                    color: Color(0xFFD9AD26),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AppoinmentPage(appointment: widget.data),
                        ));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFFD9AD26),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  TextStyle styleText() {
    return GoogleFonts.inter(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0);
  }
}
