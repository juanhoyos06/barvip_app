import 'package:barvip_app/controllers/CommentController.dart';
import 'package:barvip_app/controllers/QualifyController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Qualify.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:barvip_app/views/pages/CreateAppointmentPage.dart';
import 'package:barvip_app/views/pages/CreateCommentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BarberPage extends StatefulWidget {
  final Map<String, dynamic> barber;

  BarberPage({required this.barber});

  @override
  State<BarberPage> createState() => _BarberPageState();
}

class _BarberPageState extends State<BarberPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHeartSelected = false;
  // TODO: Logica para saber si el barbero es favorito.
  // final TextEditingController _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  QualifyController qualifyController = QualifyController();

  bool isQualified = true;
  int? _selectedNumber;
  late String averageScore = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeSelectedNumber();
  }

  Future<void> _initializeSelectedNumber() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    double score =
        await qualifyController.getAverageQualify(widget.barber['id']);

    print('SCORE --------------------------------------------$score');

    averageScore = score.toStringAsFixed(1);

    int qualify = await qualifyController.getSpecificQualify(
        widget.barber['id'], userProvider.users['id']);
    if (qualify != 6) {
      _selectedNumber = qualify;
    }
    setState(() {});
  }

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
            info(context),
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

  info(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 0, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: 'Score: ',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
                const WidgetSpan(
                    child: Icon(
                  Icons.star,
                  color: MyColors.ButtonColor,
                  size: 25,
                )),
                TextSpan(
                  text: averageScore,
                  style: const TextStyle(
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
              qualifyForm(context),
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

  Consumer<UserProvider> qualifyForm(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
                    decoration: decoration(''),
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
                      if (isQualified) {
                        setState(() {
                          _selectedNumber = newValue;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print(
                                'Numero seleccionado --------------------------------$_selectedNumber');
                            Qualify qualify = Qualify(
                              idClient: userProvider.users['id'],
                              idBarber: widget.barber['id'],
                              qualify: _selectedNumber.toString(),
                              date: DateTime.now().toIso8601String(),
                            );

                            // Guardar los datos en Firestore
                            Map<String, dynamic> result =
                                await qualifyController
                                    .saveData(qualify.toJson());

                            // Manejar el resultado
                            if (result['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text(' Successfully saved data')),
                              );
                              await _initializeSelectedNumber();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error saving data')),
                              );
                            }
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
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
      hintText: hintText ?? '',
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
