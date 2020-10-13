import 'package:flutter/material.dart';
import 'package:app/widgets/sign_in_form.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {
  static final String routeName = '/signInRoute';

  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/logo_red.svg',
              semanticsLabel: 'Hairdressing Project logo - red',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Text('Sign In', style: Theme.of(context).textTheme.headline1),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            SignInForm(),
            Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Text("Forgot password?")),
            Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text("Not registered yet? Create an account")),
          ],
        ),
      )),
    );
  }
}
