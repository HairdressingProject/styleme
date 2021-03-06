import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/views/pages/sign_in.dart';

void main() {
  runApp(StyleMe());
}

class StyleMe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StyleMeState();
}

class StyleMeState extends State<StyleMe> {
  Future<User> _authenticatedUser;

  @override
  void initState() {
    super.initState();
    _authenticatedUser = Authentication.authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hairdressing Project DEMO',
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          primaryColor: Color.fromARGB(255, 249, 9, 17),
          backgroundColor: Color.fromARGB(255, 236, 239, 241),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Klavika',
          buttonColor: Color.fromARGB(255, 38, 166, 154),
          buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              disabledColor: Color.fromARGB(255, 96, 96, 96),
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(secondary: Colors.white),
              textTheme: ButtonTextTheme.accent),
          disabledColor: Color.fromARGB(255, 96, 96, 96),
          textTheme: TextTheme(
              headline1: TextStyle(
                  color: Color.fromARGB(255, 0, 6, 64),
                  fontFamily: 'Klavika',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0),
              headline2: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 0, 6, 64),
                  fontFamily: 'Klavika',
                  letterSpacing: 1.0),
              bodyText1: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 16,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500),
              bodyText2: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5))),
      home: FutureBuilder<User>(
        future: _authenticatedUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.id != -1) {
              // user is authenticated
              return Home(
                user: snapshot.data,
              );
            }
            return SignIn();
          } else if (snapshot.hasError) {
            return SignIn();
          }
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
