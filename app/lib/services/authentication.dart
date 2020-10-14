import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Authentication {
  static Future<Response> signIn({@required UserSignIn user}) async {
    String signInUri = Uri.encodeFull('$USERS_API_URL/users/sign_in');
    String encodedUser = jsonEncode(user);

    print('Sending sign in request to $signInUri');
    print('Request body: $encodedUser');
    return await post(signInUri, body: encodedUser, headers: {
      "Content-Type": "application/json",
      "Origin": ADMIN_PORTAL_URL
    });
  }

  static Future<Response> signUp({@required UserSignUp user}) async {
    String signUpUri = Uri.encodeFull('$USERS_API_URL/users/sign_up');
    String encodedUser = jsonEncode(user);

    print('Sending sign up request to $signUpUri');
    print('Request body: $encodedUser');
    return await post(signUpUri, body: encodedUser, headers: {
      "Content-Type": "application/json",
      "Origin": ADMIN_PORTAL_URL
    });
  }
}
