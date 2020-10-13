import 'package:flutter/material.dart';
import 'package:app/widgets/logo_banner.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/sign_up_form.dart';

class SignUp extends StatefulWidget {

  static final String routeName = '/signUpRoute';

  SignUp({Key key}) : super(key: key);


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              LogoBanner(logoPath: 'assets/icons/woman.png'),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold
                )
              ),
              SignUpForm(),
              // Padding(padding: const EdgeInsets.only(top: 35.0),
              //   child: CustomButton(text: "Sign up", enabled: true,)
              // ),
              Padding(padding: const EdgeInsets.only(top: 5.0),
                child: Text("Already registered? Sign in")
              ),
            ],
          ),
        )
        
      ),
    );
  }
}
