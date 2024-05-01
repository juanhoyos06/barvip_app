import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:barvip_app/views/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LobbyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 230, 0, 0),
                child: getLogo(),
              ),
            ),
            getButtons(context),
          ],
        ));
  }

  Column getButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RegisterPage(),
            ));
          },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFFD9AD26)),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
          },
          child: RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: 'Already a member?  ',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 0,
                )),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ])),
        ),
      ],
    );
  }

  Column getLogo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'lib/assets/images/LogoBarVip-removebg-preview.png'),
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                    text: 'Luxe Cuts:',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    )),
                TextSpan(
                  text: ' Where Style Meets Precision ',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    color: Color(0xFFD9AD26),
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                )
              ],
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
