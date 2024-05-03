import 'package:flutter/material.dart';

class DashBoardBarberPage extends StatefulWidget {
  const DashBoardBarberPage({super.key});

  @override
  State<DashBoardBarberPage> createState() => _DashBoardBarberPageState();
}

class _DashBoardBarberPageState extends State<DashBoardBarberPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('DashBoardBarberPage'),
      ),
    );
  }
}
