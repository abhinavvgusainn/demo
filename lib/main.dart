import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    required this.fact,
    required this.length,
  });

  String fact;
  int length;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        fact: json["fact"],
        length: json["length"],
      );

  Map<String, dynamic> toJson() => {
        "fact": fact,
        "length": length,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<Model> _future;
  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<Model> fetchData() async {
    final res = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if (res.statusCode == 200) {
      return Model.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '  Cat Fact!',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Container(
                    height: 565,
                    width: 400,
                    color: Colors.deepPurple[300],
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Text('Meaw!',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30)),
                          Divider(
                            thickness: 2,
                          ),
                          Text(
                            snapshot.data!.fact,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }
        },
      ),
    );
  }
}
