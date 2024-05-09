import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:barvip_app/views/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
          textTheme: GoogleFonts.soraTextTheme(),
          colorSchemeSeed: Colors.white),
      home: Scaffold(
        body: Center(
          child: LobbyPage(),
        ),
      ),
    );
  }
}
