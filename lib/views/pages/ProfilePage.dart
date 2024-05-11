import 'package:barvip_app/utils/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BackgroundColor,
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  minRadius: MediaQuery.of(context).size.width * 0.14,
                  backgroundImage: Image.network(
                          "https://static.retail.autofact.cl/blog/c_img_740x370.fqrji8l39f4gkn.jpg")
                      .image,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Text(
                  'Welcome ',
                  style: GoogleFonts.sora(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        child: Icon(
                          Icons.person_outlined,
                          color: MyColors.ButtonColor,
                        )),
                    title: Text(
                      'Edit Profile',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout_outlined,
                    ),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
