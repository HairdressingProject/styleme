import 'dart:io';

import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  @override
  void initState() {
    super.initState();
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<SignUpFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _givenNameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isProcessing = false;
  String _errorMsg;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // given name
  bool _isGivenNameTouched = false;
  bool _isGivenNameValid = false;
  String _givenNameErrorMsg;

  _setGivenNameTouched() {
    setState(() {
      _isGivenNameTouched = true;
    });
  }

  String _validateGivenName(String input) {
    if (input.trim().isEmpty) {
      String errorMsg = 'Given name is required';
      setState(() {
        _isGivenNameValid = false;
        _givenNameErrorMsg = errorMsg;
      });
      return errorMsg;
    }

    if (input.length > 128) {
      String errorMsg = 'Given name should contain at most 128 characters';
      setState(() {
        _isGivenNameValid = false;
        _givenNameErrorMsg = errorMsg;
      });
      return errorMsg;
    }

    setState(() {
      _isGivenNameValid = true;
      _givenNameErrorMsg = null;
    });
    return null;
  }

  // family name
  bool _isFamilyNameTouched = false;
  bool _isFamilyNameValid = true;
  String _familyNameErrorMsg;

  _setFamilyNameTouched() {
    setState(() {
      _isFamilyNameTouched = true;
    });
  }

  String _validateFamilyName(String input) {
    if (input.length > 128) {
      String errorMsg = 'Family name should contain at most 128 characters';
      setState(() {
        _isEmailValid = false;
        _emailErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    setState(() {
      _isFamilyNameValid = true;
      _familyNameErrorMsg = null;
    });
    return null;
  }

  // email
  bool _isEmailTouched = false;
  bool _isEmailValid = false;
  String _emailErrorMsg;

  _setEmailTouched() {
    setState(() {
      _isEmailTouched = true;
    });
  }

  String _validateEmail(String input) {
    if (input.trim().isEmpty) {
      String errorMsg = 'Email is required';
      setState(() {
        _isEmailValid = false;
        _emailErrorMsg = errorMsg;
      });
      return errorMsg;
    }

    if (input.length > 512) {
      String errorMsg = 'Email should contain at most 512 characters';
      setState(() {
        _isEmailValid = false;
        _emailErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(input)) {
      String errorMsg = 'Invalid email format';
      setState(() {
        _isEmailValid = false;
        _emailErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    setState(() {
      _isEmailValid = true;
      _emailErrorMsg = null;
    });
    return null;
  }

  // username
  bool _isUsernameTouched = false;
  bool _isUsernameValid = false;
  String _usernameErrorMsg;

  _setUsernameTouched() {
    setState(() {
      _isUsernameTouched = true;
    });
  }

  String _validateUsername(String input) {
    if (input.trim().isEmpty) {
      String errorMsg = 'Username is required';
      setState(() {
        _isUsernameValid = false;
        _usernameErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (input.trim().length > 32) {
      String errorMsg = 'Username must contain at most 32 characters';
      setState(() {
        _isUsernameValid = false;
        _usernameErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    setState(() {
      _isUsernameValid = true;
      _usernameErrorMsg = null;
    });
    return null;
  }

  // password
  bool _isPasswordTouched = false;
  bool _isPasswordValid = false;
  String _passwordErrorMsg;
  bool _obscurePassword = true;

  _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  _setPasswordTouched() {
    setState(() {
      _isPasswordTouched = true;
    });
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

    if (passwordInput != _confirmPasswordController.text) {
      String errorMsg = 'Passwords do not match';
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

  // confirm password
  bool _isConfirmPasswordTouched = false;
  bool _isConfirmPasswordValid = false;
  String _confirmPasswordErrorMsg;
  bool _obscureConfirmPassword = true;

  _setConfirmPasswordTouched() {
    setState(() {
      _isConfirmPasswordTouched = true;
    });
  }

  _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  String _validateConfirmPassword(String confirmPasswordInput) {
    if (confirmPasswordInput.trim().isEmpty) {
      String errorMsg = 'Password confirmation is required';
      setState(() {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (confirmPasswordInput.trim().length < 6) {
      String errorMsg = 'Password should contain at least 6 characters';
      setState(() {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorMsg = errorMsg;
      });
      return errorMsg;
    }
    if (confirmPasswordInput.length > 512) {
      String errorMsg =
          'Password confirmation should contain at most 512 characters';
      setState(() {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorMsg = errorMsg;
      });
      return errorMsg;
    }

    if (confirmPasswordInput != _passwordController.text) {
      String errorMsg = 'Passwords do not match';
      setState(() {
        _isConfirmPasswordValid = false;
        _confirmPasswordErrorMsg = errorMsg;
      });
      return errorMsg;
    }

    setState(() {
      _isConfirmPasswordValid = true;
      _confirmPasswordErrorMsg = null;
    });

    _validatePassword(_passwordController.text);
    return null;
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  Future<bool> _signUp() async {
    String givenNameInput = _givenNameController.text;
    String familyNameInput = _familyNameController.text;
    String usernameInput = _usernameController.text;
    String emailInput = _emailController.text;
    String passwordInput = _passwordController.text;

    var user = UserSignUp(
        username: usernameInput,
        email: emailInput,
        givenName: givenNameInput,
        familyName: familyNameInput,
        password: passwordInput);

    try {
      final response = await Authentication.signUp(user: user);

      if (response == null) {
        setState(() {
          _errorMsg = "Our servers are currently unavailable";
        });
        return false;
      }

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        // all good, save token to file
        final tokenFile = await Authentication.saveToken(
            token: Authentication.getAuthCookie(response: response));

        if (tokenFile != null) {
          return true;
        }
      } else if (response.statusCode == HttpStatus.conflict) {
        setState(() {
          _errorMsg = "User is already registered";
        });
      } else if (response.statusCode == HttpStatus.notFound) {
        setState(() {
          _errorMsg = "Our servers are currently unavailable";
        });
      } else {
        setState(() {
          _errorMsg = "Invalid fields. Please try again.";
        });
      }
      return false;
    } catch (err) {
      print('Could not process sign up request');
      print(err);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            label: 'Given name *',
            errorMsg: _givenNameErrorMsg,
            isPassword: false,
            isTouched: _isGivenNameTouched,
            isValid: _isGivenNameValid,
            setTouched: _setGivenNameTouched,
            validation: _validateGivenName,
            controller: _givenNameController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Family name',
            errorMsg: _familyNameErrorMsg,
            isPassword: false,
            isTouched: _isFamilyNameTouched,
            isValid: _isFamilyNameValid,
            setTouched: _setFamilyNameTouched,
            validation: _validateFamilyName,
            controller: _familyNameController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Username *',
            errorMsg: _usernameErrorMsg,
            isPassword: false,
            isTouched: _isUsernameTouched,
            isValid: _isUsernameValid,
            setTouched: _setUsernameTouched,
            validation: _validateUsername,
            controller: _usernameController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Email *',
            errorMsg: _emailErrorMsg,
            isPassword: false,
            isTouched: _isEmailTouched,
            isValid: _isEmailValid,
            setTouched: _setEmailTouched,
            validation: _validateEmail,
            controller: _emailController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Password *',
            errorMsg: _passwordErrorMsg,
            isPassword: true,
            controller: _passwordController,
            isTouched: _isPasswordTouched,
            isValid: _isPasswordValid,
            setTouched: _setPasswordTouched,
            validation: _validatePassword,
            obscureText: _obscurePassword,
            toggleFieldVisibility: _togglePasswordVisibility,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          CustomFormField(
            label: 'Confirm password *',
            errorMsg: _confirmPasswordErrorMsg,
            isPassword: true,
            controller: _confirmPasswordController,
            isTouched: _isConfirmPasswordTouched,
            isValid: _isConfirmPasswordValid,
            setTouched: _setConfirmPasswordTouched,
            validation: _validateConfirmPassword,
            obscureText: _obscureConfirmPassword,
            toggleFieldVisibility: _toggleConfirmPasswordVisibility,
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

                        if (await _signUp()) {
                          // all good, navigate to Home
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
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
                      'Sign up',
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
