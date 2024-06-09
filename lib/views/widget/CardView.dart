import 'package:barvip_app/controllers/FavoriteController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Favorite.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/BarberPage.dart';
import 'package:barvip_app/views/pages/CreateAppointmentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HeartCard extends StatefulWidget {
  final Map<String, dynamic> data;
  // Data recibe un mapa con los datos que se quieren mostrar  en dashBoard, nombre del barbero, email, etc
  HeartCard({required this.data});

  @override
  _HeartCardState createState() => _HeartCardState();
}

class _HeartCardState extends State<HeartCard> {
  String? favoriteId = null;

  FavoriteController favoriteController = FavoriteController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (_, userProvider, context) {
      return Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(_).push(MaterialPageRoute(
                  builder: (context) => BarberPage(
                    barber: widget.data,
                  ),
                ));
              },
              /* onDoubleTap: () {
                setState(() {
                  userProvider.changeHeart(widget.data['id']);
                });
              }, */
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
                          color: userProvider.isHeartSelected(widget.data['id'])
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () async {
                          userProvider.favorites = await favoriteController
                              .getFavorites(userProvider.users['id']);
                          setState(() {
                            userProvider.changeHeart(widget.data['id']);
                          });
                          Favorite data = Favorite(
                            idBarber: widget.data['id'],
                            idClient: userProvider.users['id'],
                          );
                          print(data.toJson());

                          if (userProvider.isHeartSelected(widget.data['id'])) {
                            favoriteId = await favoriteController
                                .addFavorite(data.toJson());
                          } else {
                            print("ENTRE A ELIMINAR");
                            await favoriteController
                                .deleteFavorite(widget.data['id']);
                          }
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
    });
  }
}
