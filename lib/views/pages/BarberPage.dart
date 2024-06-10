import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/CreateAppointmentPage.dart';
import 'package:barvip_app/views/pages/CreateCommentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarberPage extends StatefulWidget {
  final Map<String, dynamic> barber;

  BarberPage({required this.barber});

  @override
  State<BarberPage> createState() => _BarberPageState();
}

class _BarberPageState extends State<BarberPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHeartSelected = false;
  // final TextEditingController _controller = TextEditingController();
  int? _selectedNumber;
  // TODO: Logica para saber si el barbero es favorito.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                img(),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.08,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(255, 28, 33, 39),
                    ),
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            title(),
            info(),
            bottons(),
          ],
        ),
      ),
    );
  }

  title() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.barber['name'],
            style: GoogleFonts.sora(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isHeartSelected ? Colors.red : Colors.grey,
              size: 40,
            ),
            onPressed: () {
              setState(() {
                isHeartSelected = !isHeartSelected;
                // TODO: Implementar la lógica para guardar el like en la base de datos
              });
            },
          ),
        ],
      ),
    );
  }

  img() {
    return Container(
      width: double.infinity, // Para asegurar que la imagen ocupe todo el ancho
      child: Image.network(
        widget.barber['urlImage'],
        fit: BoxFit.cover,
      ),
    );
  }

  InputDecoration decorationFields() {
    return InputDecoration(
      fillColor: Color.fromARGB(255, 28, 33, 39),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 28, 33, 39),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  info() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 0, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                    text: 'Score: ',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
                WidgetSpan(
                    child: Icon(
                  Icons.star,
                  color: MyColors.ButtonColor,
                  size: 25,
                )),
                TextSpan(
                  text: ' 4,5',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0,
                  ),
                ),
              ])),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Text('Contact:',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
              ),
              Text(widget.barber['email'],
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  )),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Text('Qualify:',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
              ),
              qualifyForm(),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Text('Comment:',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
              ),
              commentForm(),
            ],
          ),
        ),
      ],
    );
  }

  Padding qualifyForm() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 40, 0),
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                menuMaxHeight: 200,
                value: _selectedNumber,
                hint: const Text(
                  'Choose a number',
                  style: TextStyle(color: Colors.white),
                ),
                isExpanded: false,
                dropdownColor: const Color.fromARGB(255, 46, 46, 46),
                decoration: decorationFields(),
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                items: List<DropdownMenuItem<int>>.generate(6, (int index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(
                      index.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedNumber = newValue;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: metodo para guardar la calificacion
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Padding commentForm() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 40, 0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: decoration("Enter a comment"),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: metodo para guardar el comentario
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  InputDecoration decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(108, 255, 255, 255)),
      fillColor: const Color.fromARGB(255, 28, 33, 39),
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 28, 33, 39),
          width: 1,
        ),
      ),
    );
  }

  bottons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 67, 67, 67)),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateAppointmentPage(
                idBarber: widget.barber['id'],
              ),
            ));
          },
          child: const Text(
            "Schedule now",
            style: TextStyle(color: MyColors.ButtonColor, fontSize: 18),
          ),
        ),

      ],
    );
  }
}
