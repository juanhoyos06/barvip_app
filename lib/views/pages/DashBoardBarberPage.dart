import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/listAppoinments.dart';
import 'package:barvip_app/views/widget/CardView.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:barvip_app/views/widget/NavigationBarView.dart';
import 'package:barvip_app/views/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardBarberPage extends StatefulWidget {
  const DashBoardBarberPage({super.key});

  @override
  State<DashBoardBarberPage> createState() => _DashBoardBarberPageState();
}

class _DashBoardBarberPageState extends State<DashBoardBarberPage> {
  UserController _userController = UserController();
  // para saber en que pagina del navigator estamos
  int currentPageIndex = 0;
  // Para el like

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom Navigation Bar esta en el archivo NavigationBarView.dart
      bottomNavigationBar: CustomNavigationBar(
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
        BarbersGrid(),
        ListAppoinments(),
        ProfilePage()
      ][currentPageIndex],
    );
  }

  Column BarbersGrid() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 80, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Barbers',
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
          stream: _userController.usersStream(),
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
