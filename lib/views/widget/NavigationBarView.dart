import "package:barvip_app/utils/MyColors.dart";
import "package:flutter/material.dart";

class CustomNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onDestinationSelected;

  CustomNavigationBar({
    required this.currentPageIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: currentPageIndex,
      selectedItemColor: MyColors.ButtonColor,
      unselectedItemColor: MyColors.SecondaryColor,
      onTap: onDestinationSelected,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Barbers',
        ),
        BottomNavigationBarItem(
          icon: Badge(child: Icon(Icons.calendar_month_sharp)),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
