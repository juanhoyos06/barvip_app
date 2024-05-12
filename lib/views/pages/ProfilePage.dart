import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/EditPage.dart';
import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<UserProvider>(builder: (_, userProvider, __) {
        return Container(
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
                    backgroundImage:
                        Image.network('${userProvider.users['urlImage']}')
                            .image,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Flexible(
                    child: Text(
                      'Welcome, ${userProvider.users['name']}!',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPage(),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                          backgroundColor: MyColors.ButtonColor,
                          child: Icon(
                            Icons.person_outlined,
                            color: MyColors.BackgroundColor,
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: MyColors.ButtonColor,
                        child: Icon(
                          Icons.logout_outlined,
                        ),
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
        );
      }),
    );
  }
}
