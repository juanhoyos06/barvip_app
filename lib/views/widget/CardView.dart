import 'package:barvip_app/controllers/BarberController.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/BarberPage.dart';
import 'package:barvip_app/views/pages/CreateAppointmentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeartCard extends StatefulWidget {
  final Map<String, dynamic> data;
  // Data recibe un mapa con los datos que se quieren mostrar  en dashBoard, nombre del barbero, email, etc
  HeartCard({required this.data});

  @override
  _HeartCardState createState() => _HeartCardState();
}

class _HeartCardState extends State<HeartCard> {
  bool isHeartSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BarberPage(
                  barber: widget.data,
                ),
              ));
            },
            onDoubleTap: () {
              setState(() {
                isHeartSelected = !isHeartSelected;
              });
            },
            child: Card.outlined(
              color: MyColors.TextInputColor,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          18), // debe ser igual al valor de la tarjeta
                      child: Image.network(
                        widget.data['urlImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    bottom: 8.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isHeartSelected ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isHeartSelected = !isHeartSelected;
                          // TODO: Implementar la lógica para guardar el like en la base de datos
                        });
                      },
                    ),
                  ),
                  //Text(
                  //'Name: ${widget.data['name']}',
                  //style: TextStyle(color: MyColors.SecondaryColor),
                  //),
                  //Text('Email: ${data['email']}'),
                  // Agrega más campos según sea necesario
                ],
              ),
            ),
          ),
        ),
        Text(
          '${widget.data['name']}',
          style: const TextStyle(color: MyColors.SecondaryColor),
        ),
      ],
    );
  }
}
