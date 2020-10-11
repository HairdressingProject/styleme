import 'dart:async';

import 'package:flutter/material.dart';
import 'package:style_me_flutter/views/pages/home.dart';
import 'package:style_me_flutter/widgets/logo_banner.dart';
import 'package:style_me_flutter/views/pages/sign_in.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hairdressing Project DEMO',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      theme: ThemeData(        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Klavika'
      ),
      home: SplashScreen(),
      routes: {
        SignIn.routeName: (context) => SignIn(),
        Home.routeName: (context) => Home()
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
            child: LogoBanner(logoPath: 'assets/woman.png')
          )
        )
      ),
    );
  }
}
