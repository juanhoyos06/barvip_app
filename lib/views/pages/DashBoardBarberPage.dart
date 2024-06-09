import 'dart:math';

import 'package:barvip_app/controllers/FavoriteController.dart';
import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/listAppoinments.dart';
import 'package:barvip_app/views/widget/CardView.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:barvip_app/views/widget/NavigationBarberView.dart';
import 'package:barvip_app/views/widget/NavigationClientView.dart';
import 'package:barvip_app/views/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashBoardBarberPage extends StatefulWidget {
  const DashBoardBarberPage({super.key});

  @override
  State<DashBoardBarberPage> createState() => _DashBoardBarberPageState();
}

class _DashBoardBarberPageState extends State<DashBoardBarberPage> {
  UserController _userController = UserController();
  FavoriteController favoriteController = FavoriteController();
  // para saber en que pagina del navigator estamos
  int currentPageIndex = 0;
  // Para el like

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, userProvider, context) {
        return userProvider.users['typeUser'] == 'client'
            ? Scaffold(
                // Custom Navigation Bar esta en el archivo NavigationBarView.dart
                bottomNavigationBar: CustomNavigationClient(
                  currentPageIndex: currentPageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                ),
                backgroundColor: MyColors.BackgroundColor,
                // Aqui colocan las paginas que quieren mostrar
                body: <Widget>[
                  BarbersGrid(userProvider),
                  ListAppoinments(),
                  ProfilePage()
                ][currentPageIndex],
              )
            : Scaffold(
                // Custom Navigation Bar esta en el archivo NavigationBarView.dart
                bottomNavigationBar: CustomNavigationBarber(
                  currentPageIndex: currentPageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                ),
                backgroundColor: MyColors.BackgroundColor,
                // Aqui colocan las paginas que quieren mostrar
                body: <Widget>[
                  ListAppoinments(),
                  ProfilePage()
                ][currentPageIndex],
              );
      },
    );
  }

  Column BarbersGrid(UserProvider userProvider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 80, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  'Barbers',
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    userProvider.filter();
                      userProvider.favorites = await favoriteController
                          .getFavorites(userProvider.users['id']);
                      print(
                          "Estos son los favoritos ${userProvider.favorites}");
                      print(userProvider.filterFav);
                     
                    setState(() {
                      userProvider.favorites;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: 20), // Ajusta el valor según tus necesidades
                    child: Icon(
                      Icons.favorite,
                      color: userProvider.filterFav ? Colors.red : Colors.grey,
                      size: 50, // Ajusta el valor según tus necesidades
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 3, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Home haircut? Find your perfect barber for personalized service!',
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _userController.usersStream(userProvider),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return Expanded(
              child: GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  // data contiene los datos de cada barbero
                  // data['name'] = nombre del barbero
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  if (userProvider.filterFav &&!userProvider.favorites.contains(data['id'])) {
                    return Container(); // Devuelve un contenedor vacío para los barberos no favoritos
                  }

                  /* print("Este es el id de sebas ${userProvider.users['id']}");
                  print("Este es el id del barbero ${data['id']}"); */
                  return HeartCard(
                    data: data,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
