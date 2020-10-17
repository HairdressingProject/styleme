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

  static Future<int> retrieveIdFromToken() async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final authResponse = await get(
            Uri.encodeFull('$PICTURES_API_URL/users/authenticate'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: 5));

        final authData =
            UserAuthenticate.fromJson(jsonDecode(authResponse.body));

        return authData.id;
      }
    } catch (err) {
      print('Failed to authenticate user in order to retrieve history');
      print(err);
      return null;
    }
    return null;
  }

  static Future<User> authenticate() async {
    User nullUser = User(
        id: -1, username: null, email: null, givenName: null, userRole: null);

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
            final UserAuthenticate authenticatedUserData =
                UserAuthenticate.fromJson(jsonDecode(response.body));

            final userUri = Uri.encodeFull(
                '$USERS_API_URL/users/${authenticatedUserData.id}');

            final userResponse = await get(userUri, headers: {
              "Authorization": "Bearer $localToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: 5), onTimeout: () => null);

            if (userResponse.statusCode == HttpStatus.ok) {
              final user = User.fromJson(jsonDecode(userResponse.body)['user']);
              return user;
            }
          }
          return nullUser;
        } catch (err) {
          print('Authentication attempt timed out');
          print(err);
          return nullUser;
        }
      }
      return nullUser;
    } catch (err) {
      print('Authentication failed');
      print(err);
      return nullUser;
    }
  }

  static Future<void> signOut() async {
    // delete locally stored token file
    await _deleteToken();
  }
}
