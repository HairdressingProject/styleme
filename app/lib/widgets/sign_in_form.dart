import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<SignInFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username or email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Username or email is required';
              }
              return null;
            },
          ),
          // TextFormField(
          //   decoration: InputDecoration(
          //     labelText: 'Email',
          //   ),
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Email is required';
          //     }
          //     else {
          //       if (!validateEmail(value)) {
          //         return 'This does not look like a valid email';
          //       }
          //     }
          //     return null;
          //   },
          // ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: _obscureText,
            controller: _password,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password is required';
              }
              else {
                if(value.length < 6) {
                  return 'Password should contain at least 6 characters';
                }
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0),
            child: MaterialButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              color: Color.fromARGB(255, 74, 169, 242),
              minWidth: double.infinity,              
              child: Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }
}