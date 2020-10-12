import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/logo_banner.dart';
import 'package:app/views/pages/sign_in.dart';
import 'package:app/views/pages/sign_up.dart';
import 'package:app/views/pages/select_face_shape.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hairdressing Project DEMO',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      theme: ThemeData(      
        buttonColor: Colors.blueAccent,  
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Klavika',
        disabledColor: Colors.grey
      ),
      home: SplashScreen(),
      routes: {
        SignIn.routeName: (context) => SignIn(),
        Home.routeName: (context) => Home(),
        SignUp.routeName: (context) => SignUp(),
        SelectFaceShape.routeName: (context) => SelectFaceShape()
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key,}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(SignIn.routeName);
      Navigator.of(context).pushReplacementNamed(Home.routeName);
      Navigator.of(context).pushReplacementNamed(SelectFaceShape.routeName);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Align(
            alignment: Alignment.center,
            child: LogoBanner(logoPath: 'assets/icons/woman.png')
          )
        )
      ),
    );
  }
}
