import 'dart:ui';

import 'package:barvip_app/controllers/CommentController.dart';
import 'package:barvip_app/controllers/QualifyController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/Comment.dart';
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
  final TextEditingController _commentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  QualifyController qualifyController = QualifyController();
  CommentController commentController = CommentController();

  bool isQualified = true;
  List<Comment> _comments = [];
  int? _selectedNumber;
  late String averageScore = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeSelectedNumber();
    _fetchComments();
  }

  Future<void> _initializeSelectedNumber() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    double score =
        await qualifyController.getAverageQualify(widget.barber['id']);

    averageScore = score.toStringAsFixed(1);

    int qualify = await qualifyController.getSpecificQualify(
        widget.barber['id'], userProvider.users['id']);
    if (qualify != 6) {
      _selectedNumber = qualify;
    }

    String comment = await commentController.getSpecificComment(
        widget.barber['id'], userProvider.users['id']);

    if (comment.isNotEmpty) {
      _commentController.text = comment;
    }

    setState(() {});
  }

  Future<void> _fetchComments() async {
    List<Comment> comments =
        await commentController.getCommentsForBarber(widget.barber['id']);
    setState(() {
      _comments = comments; // Asignar los comentarios traídos a la lista
    });
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
                child: Text('Comments:',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 25,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    )),
              ),
              // const SizedBox(height: 20),
              Container(
                height: 100,
                alignment:
                    Alignment.topCenter, // Altura específica para el ListView
                child: listComments(),
              ),
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
              commentForm(context),
            ],
          ),
        ),
      ],
    );
  }


  Widget listComments() {
    if (_comments.isEmpty) {
      return const Center(
        child: Text('This barber has no reviews yet'),
      );
    }

    return ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          Comment comment = _comments[index];
          return ListTile(
              title:
                  Text(comment.comment, style: TextStyle(color: Colors.white)),
              subtitle:
                  Text(comment.date, style: TextStyle(color: Colors.grey)));
        });
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
                                  content: Text(' Successfully saved data'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await _initializeSelectedNumber();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error saving data'),
                                  backgroundColor: Colors.red,
                                ),
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

  Consumer<UserProvider> commentForm(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 40, 0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _commentController,
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
                          onPressed: () async {
                            Comment comment = Comment(
                                idClient: userProvider.users['id'],
                                idBarber: widget.barber['id'],
                                comment: _commentController.text,
                                date: DateTime.now().toIso8601String());

                            Map<String, dynamic> result =
                                await commentController
                                    .saveData(comment.toJson());

                            if (result['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(' Successfully saved data'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await _initializeSelectedNumber();
                              await _fetchComments();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error saving data'),
                                    backgroundColor: Colors.red),
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
