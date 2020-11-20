import 'dart:convert';
import 'dart:io';

import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  @override
  void initState() {
    super.initState();
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<SignInFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  bool _isUsernameOrEmailTouched = false;
  bool _isUsernameOrEmailValid = false;
  String _usernameOrEmailErrorMsg;
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordTouched = false;
  bool _isPasswordValid = false;
  String _passwordErrorMsg;
  bool _obscureText = true;
  bool _isProcessing = false;
  String _errorMsg;
  User _user;

  _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _setUsernameOrEmailTouched() {
    if (!_isUsernameOrEmailTouched) {
      setState(() {
        _isUsernameOrEmailTouched = true;
      });
    }
  }

  _setPasswordTouched() {
    if (!_isPasswordTouched) {
      setState(() {
        _isPasswordTouched = true;
      });
    }
  }

  String _validateUsernameOrEmail(String usernameInput) {
    if (usernameInput.trim().isEmpty) {
      String errorMsg = 'Username or email is required';
      setState(() {
        _isUsernameOrEmailValid = false;
        _usernameOrEmailErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (usernameInput.length > 512) {
      String errorMsg =
          'Username or email should contain at most 512 characters';
      setState(() {
        _isUsernameOrEmailValid = false;
        _passwordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    setState(() {
      _isUsernameOrEmailValid = true;
      _usernameOrEmailErrorMsg = null;
    });
    return null;
  }

  String _validatePassword(String passwordInput) {
    if (passwordInput.trim().isEmpty) {
      String errorMsg = 'Password is required';
      setState(() {
        _isPasswordValid = false;
        _passwordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (passwordInput.trim().length < 6) {
      String errorMsg = 'Password should contain at least 6 characters';
      setState(() {
        _isPasswordValid = false;
        _passwordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (passwordInput.length > 512) {
      String errorMsg = 'Password should contain at most 512 characters';
      setState(() {
        _isPasswordValid = false;
        _passwordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    setState(() {
      _isPasswordValid = true;
      _passwordErrorMsg = null;
    });
    return null;
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  Future<bool> _signIn() async {
    String usernameOrEmailInput = _usernameOrEmailController.text;
    String passwordInput = _passwordController.text;

    var user = UserSignIn(
        usernameOrEmail: usernameOrEmailInput, password: passwordInput);

    try {
      final response = await Authentication.signIn(user: user);

      if (response == null) {
        setState(() {
          _errorMsg = "Our servers are currently unavailable";
        });
        return false;
      }

      if (response != null &&
          response.statusCode == HttpStatus.ok &&
          response.body.isNotEmpty) {
        // all good, save token to file
        final user = User.fromJson(jsonDecode(response.body));

        await Authentication.saveToken(
            token: Authentication.getAuthToken(response: response), user: user);

        setState(() {
          _user = user;
        });
        return true;
      } else {
        setState(() {
          _errorMsg = "Invalid username, email or password";
        });
      }
    } catch (err) {
      print('Could not process sign in request');
      print(err);
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            label: 'Username or email *',
            errorMsg: _usernameOrEmailErrorMsg,
            isPassword: false,
            isTouched: _isUsernameOrEmailTouched,
            isValid: _isUsernameOrEmailValid,
            setTouched: _setUsernameOrEmailTouched,
            validation: _validateUsernameOrEmail,
            controller: _usernameOrEmailController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Password *',
            errorMsg: _passwordErrorMsg,
            isPassword: true,
            isTouched: _isPasswordTouched,
            isValid: _isPasswordValid,
            setTouched: _setPasswordTouched,
            validation: _validatePassword,
            obscureText: _obscureText,
            toggleFieldVisibility: _togglePasswordVisibility,
            controller: _passwordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: MaterialButton(
              disabledColor: Colors.grey[600],
              disabledTextColor: Colors.white,
              onPressed: !_isProcessing
                  ? () async {
                      if (_validateForm()) {
                        // send request to authenticate data with Users API
                        setState(() {
                          _isProcessing = true;
                        });

                        if (await _signIn()) {
                          // all good, navigate to Home
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(user: _user)));
                        } else {
                          // display error message
                          setState(() {
                            _isProcessing = false;
                          });

                          Scaffold.of(context).showSnackBar(SnackBar(
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  Scaffold.of(context).hideCurrentSnackBar();
                                },
                              ),
                              content: Text(
                                _errorMsg,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                              )));
                        }
                      }
                    }
                  : null,
              color: Color.fromARGB(255, 74, 169, 242),
              minWidth: double.infinity,
              child: !_isProcessing
                  ? Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    )
                  : Center(
                      child: Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: Color.fromARGB(255, 38, 166, 154),
                      ),
                      child: CircularProgressIndicator(),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}
