import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<SignUpFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
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
              labelText: 'Given name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Given name is required';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Family name',
            ),
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Family name is required';
            //   }
            //   return null;
            // },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Email is required';
              }
              else {
                if (!validateEmail(value)) {
                  return 'This does not look like a valid email';
                }
              }
              return null;
            },
          ),
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm password',
            ),
            obscureText: _obscureText,
            controller: _confirmPassword,
            validator: (value) {
              if (value.isEmpty) {
                return 'Confirm password is required';
              }
              else {
                if(value != _password.text) {
                  return 'Passwords do not match';
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
              child: Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}