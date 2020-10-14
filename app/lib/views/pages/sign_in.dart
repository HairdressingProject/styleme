import 'package:app/views/pages/sign_up.dart';
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
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: InkWell(
                  onTap: () {
                    // Forgot password has not yet been implemented in the app
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => null));
                  },
                  child: Text("Forgot password?",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 6, 64))
                      // color: Color.fromARGB(255, 124, 62, 233)),
                      )),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not registered yet?',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        'Sign up',
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
