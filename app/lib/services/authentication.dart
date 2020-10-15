import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/models/user.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Authentication {
  static Future<Response> signIn({@required UserSignIn user}) async {
    final String signInUri = Uri.encodeFull('$USERS_API_URL/users/sign_in');
    final String encodedUser = jsonEncode(user);

    try {
      final response = await post(signInUri, body: encodedUser, headers: {
        "Content-Type": "application/json",
        "Origin": ADMIN_PORTAL_URL
      }).timeout(const Duration(seconds: 5));
      return response;
    } catch (err) {
      print('Server connection timed out');
      print(err);
      return null;
    }
  }

  static Future<Response> signUp({@required UserSignUp user}) async {
    final String signUpUri = Uri.encodeFull('$USERS_API_URL/users/sign_up');
    final String encodedUser = jsonEncode(user);

    try {
      return await post(signUpUri, body: encodedUser, headers: {
        "Content-Type": "application/json",
        "Origin": ADMIN_PORTAL_URL
      }).timeout(const Duration(seconds: 5));
    } catch (err) {
      print('Server connection timed out');
      print(err);
      return null;
    }
  }

  static String getAuthCookie({@required Response response}) {
    final String rawCookie = response.headers['set-cookie'];

    if (rawCookie != null) {
      final int end = rawCookie.indexOf(';');
      return (end == -1) ? null : rawCookie.substring(5, end);
    }
    return null;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localTokenFile async {
    try {
      final path = await _localPath;
      return File('$path/$TOKEN_FILENAME');
    } catch (err) {
      print('Could not retrieve local token file');
      print(err);
      return null;
    }
  }

  static Future<File> saveToken({@required String token}) async {
    try {
      final tokenFile = await _localTokenFile;
      return tokenFile.writeAsString(token);
    } catch (err) {
      print('Could not save token to file');
      print(err);
      return null;
    }
  }

  static Future<String> retrieveToken() async {
    try {
      final tokenFile = await _localTokenFile;
      return tokenFile.readAsString();
    } catch (err) {
      print('Could not retrieve token from file');
      print(err);
      return null;
    }
  }

  static Future<void> _deleteToken() async {
    try {
      final tokenFile = await _localTokenFile;
      await tokenFile.delete();
    } catch (err) {
      print('Could not delete token file');
      print(err);
    }
  }

  static Future<UserAuthenticate> authenticate() async {
    UserAuthenticate unauthenticatedUser =
        UserAuthenticate(id: -1, userRole: 'user');

    try {
      final localToken = await retrieveToken();

      if (localToken != null && localToken.isNotEmpty) {
        final authenticationUri =
            Uri.encodeFull('$USERS_API_URL/users/authenticate');

        try {
          final response = await get(authenticationUri, headers: {
            "Authorization": "Bearer $localToken",
            "Origin": ADMIN_PORTAL_URL
          }).timeout(Duration(seconds: 5), onTimeout: () => null);

          if (response.statusCode == HttpStatus.ok) {
            final UserAuthenticate authenticatedUser =
                UserAuthenticate.fromJson(jsonDecode(response.body));
            return authenticatedUser;
          }
          return unauthenticatedUser;
        } catch (err) {
          print('Authentication attempt timed out');
          print(err);
          return unauthenticatedUser;
        }
      }
      return unauthenticatedUser;
    } catch (err) {
      print('Authentication failed');
      print(err);
      return unauthenticatedUser;
    }
  }

  static Future<void> signOut() async {
    // delete locally stored token file
    await _deleteToken();
  }
}
