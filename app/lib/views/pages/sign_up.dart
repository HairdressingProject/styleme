import 'package:app/views/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/sign_up_form.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
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
            Text('Sign Up', style: Theme.of(context).textTheme.headline1),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            SignUpForm(),
            // Padding(padding: const EdgeInsets.only(top: 35.0),
            //   child: CustomButton(text: "Sign up", enabled: true,)
            // ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already registered?',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 124, 62, 233)),
                      ),
                    )
                  ],
                )),
          ],
        ),
      )),
    );
  }
}
