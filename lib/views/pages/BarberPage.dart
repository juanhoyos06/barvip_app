import 'package:barvip_app/views/pages/CreateAppointmentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberPage extends StatefulWidget {
  final Map<String, dynamic> barber;

  BarberPage({required this.barber});

  @override
  State<BarberPage> createState() => _BarberPageState();
}

class _BarberPageState extends State<BarberPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
                    color: Color.fromARGB(255, 28, 33, 39),
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
                  widget.barber['name'],
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0),
                ),
              ),
              img(),
              info(),
              bottons()
            ],
          ),
        ),
      ),
    );
  }

  img() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(
        widget.barber['urlImage'],
        fit: BoxFit.cover,
      ),
    );
  }

  info() {
    return Column(
      children: [
        Text(
          'Name: ${widget.barber['name']}',
          style: const TextStyle(color: Colors.white),
        ),
        Text('Email: ${widget.barber['email']}'),
        // Agrega más campos según sea necesario
      ],
    );
  }

  bottons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateAppointmentPage(),
          ));
        },
        child: const Text("Schedule now"),
      )
    ]);
  }
}
