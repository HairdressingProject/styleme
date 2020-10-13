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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  bool _isUsernameOrEmailTouched = false;
  bool _isUsernameOrEmailValid = false;
  String _usernameOrEmailErrorMsg;
  bool _isPasswordTouched = false;
  bool _isPasswordValid = false;
  String _passwordErrorMsg;
  bool _obscureText = true;

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              onTap: _setUsernameOrEmailTouched,
              onChanged: _validateUsernameOrEmail,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
              decoration: InputDecoration(
                  labelText: 'Username or email *',
                  helperText: _usernameOrEmailErrorMsg,
                  helperStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.red[600]),
                  labelStyle: _isUsernameOrEmailTouched
                      ? _isUsernameOrEmailValid
                          ? TextStyle(color: Colors.green[600])
                          : TextStyle(color: Colors.red)
                      : TextStyle(color: Colors.black),
                  errorStyle: TextStyle(fontSize: 14.0),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0)),
                  enabledBorder: _isUsernameOrEmailTouched
                      ? _isUsernameOrEmailValid
                          ? UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2.0))
                          : UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0))
                      : UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                  focusedBorder: _isUsernameOrEmailValid
                      ? UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0))
                      : UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
                  suffixIcon: _isUsernameOrEmailTouched
                      ? !_isUsernameOrEmailValid
                          ? Icon(Icons.clear, color: Colors.red)
                          : Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                      : null),
              controller: _usernameOrEmailController,
              validator: _validateUsernameOrEmail),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          TextFormField(
            onTap: _setPasswordTouched,
            onChanged: _validatePassword,
            decoration: InputDecoration(
              labelText: 'Password *',
              helperText: _passwordErrorMsg,
              helperStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.red[600]),
              labelStyle: _isPasswordTouched
                  ? _isPasswordValid
                      ? TextStyle(color: Colors.green[600])
                      : TextStyle(color: Colors.red)
                  : TextStyle(color: Colors.black),
              errorStyle: TextStyle(fontSize: 14.0),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0)),
              enabledBorder: _isPasswordTouched
                  ? _isPasswordValid
                      ? UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0))
                      : UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0)),
              focusedBorder: _isPasswordValid
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: _togglePasswordVisibility,
                      child: _obscureText
                          ? Icon(Icons.visibility, color: Colors.black87)
                          : Icon(Icons.visibility_off, color: Colors.black)),
                  const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                  ),
                  _isPasswordTouched
                      ? !_isPasswordValid
                          ? Icon(Icons.clear, color: Colors.red)
                          : Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                      : null
                ].where((element) => element != null).toList(),
              ),
            ),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
            obscureText: _obscureText,
            controller: _passwordController,
            validator: _validatePassword,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
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
