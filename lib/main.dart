import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(Miapp());

class Miapp extends StatelessWidget {
  const Miapp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Myapp",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  final storage = new FlutterSecureStorage();
  TextEditingController usuario;
  TextEditingController password;
  String usu = "";
  String pass = "";
  @override
  void initState() {
    usuario = TextEditingController();
    password = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  void ingresar(usuario, password) async {
    try {
      Map data = {'email': usuario, 'password': password};
      var body = json.encode(data);

      await storage.write(
          key: 'jwt',
          value:
              'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODA4MFwvVnVlTGFyYVwvcHVibGljXC9hcGlcL2xvZ2luIiwiaWF0IjoxNjI0MjU5Nzk2LCJleHAiOjE2MjQyNjMzOTYsIm5iZiI6MTYyNDI1OTc5NiwianRpIjoibTNxTWNCelhtUFk0eEVOYiIsInN1YiI6MywicHJ2IjoiODdlMGFmMWVmOWZkMTU4MTJmZGVjOTcxNTNhMTRlMGIwNDc1NDZhYSJ9.C4rC-RS0xk5x3rcJGGSUMoo4ph2F3akHzhkJdJTyyAA');
      String token = await _getTokenFromHttp();
      var url = "http://192.168.1.72:8080/VueLara/public/api/auth/notes";
      var response = await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: body)
          .timeout(const Duration(seconds: 90));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(jsonResponse['email']);
      } else {
         var jsonResponse = json.decode(response.body);
        print(jsonResponse['email']);
      }
    } on TimeoutException catch (e) {
      print("Tardo la coneccion");
    } on Error catch (e) {
      print("Http error");
    }
  }

  Future<String> _getTokenFromHttp() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: cuerpo(),
    ));
  }

  Widget cuerpo() {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://mobimg.b-cdn.net/lwallpaper_img/night_mountains/real/1_night_mountains.jpg"),
                fit: BoxFit.cover)),
        child: Center(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              nombre(),
              campoUsuario(),
              campoConstrasena(),
              SizedBox(
                height: 15.0,
              ),
              botonEntrar()
            ],
          )),
        ));
  }

  Widget nombre() {
    return Text("Sing ing",
        style: TextStyle(
            color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold));
  }

  Widget campoUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: TextField(
        controller: usuario,
        decoration: InputDecoration(
            hintText: "User", fillColor: Colors.white, filled: true),
      ),
    );
  }

  Widget campoConstrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: TextField(
        controller: password,
        obscureText: true,
        decoration: InputDecoration(
            hintText: "Password", fillColor: Colors.white, filled: true),
      ),
    );
  }

  Widget botonEntrar() {
    return FlatButton(
        color: Colors.blueAccent,
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 10),
        onPressed: () {
          usu = usuario.text;
          pass = password.text;
          ingresar(usu, pass);
          usuario.clear();
          password.clear();
        },
        child: Text(
          "Entrar",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }
}
