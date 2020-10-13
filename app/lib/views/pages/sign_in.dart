import 'package:flutter/material.dart';
import 'package:app/widgets/logo_banner.dart';
import 'package:app/widgets/sign_in_form.dart';

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
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LogoBanner(logoPath: 'assets/icons/woman.png'),
            Text('Sign In', style: Theme.of(context).textTheme.headline1),
            // Form(
            //   child: Column(
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.only(top: 35.0),
            //         child: TextFormField(
            //           decoration:
            //               InputDecoration(labelText: 'Username or email'),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 35.0),
            //         child: TextFormField(
            //           decoration: InputDecoration(labelText: 'Password'),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            SignInForm(),
            Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Text("Forgot password?")),
            // Padding(
            //   padding: const EdgeInsets.only(top: 35.0),
            //   child: MaterialButton(
            //     onPressed: () {},
            //     child: Text(
            //       'Sign in',
            //       style: Theme.of(context).textTheme.bodyText1.copyWith(
            //           color: Colors.white, fontWeight: FontWeight.w700),
            //     ),
            //     color: Color.fromARGB(255, 74, 169, 242),
            //     height: MediaQuery.of(context).size.height / 15,
            //     minWidth: double.infinity,
            //   ),
            // ),
            Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text("Not registered yet? Create an account")),
          ],
        ),
      )),
    );
  }
}
