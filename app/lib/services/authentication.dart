import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/models/user.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/services/db.dart';

/// Handles authentication (sign in, sign up) and manages the current user's
/// token, which is saved locally to a text file
class Authentication {
  /// Sends a request to /users/sign_in with the appropriate headers
  ///
  /// The [user] object will be encoded as json and sent in the request body
  ///
  /// Returns the `Response` received from the API or `null` if the connects times out
  static Future<Response> signIn({@required UserSignIn user}) async {
    final String signInUri = Uri.encodeFull('$USERS_API_URL/users/sign_in');
    final String encodedUser = jsonEncode(user);

    try {
      final response = await post(signInUri, body: encodedUser, headers: {
        "Content-Type": "application/json",
        "Origin": ADMIN_PORTAL_URL
      }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
      return response;
    } catch (err) {
      print('Server connection timed out');
      print(err);
      return null;
    }
  }

  /// Sends a request to /users/sign_up with the appropriate headers
  ///
  /// The [user] object will be encoded as json and sent in the request body
  ///
  /// Returns the `Response` received from the API or `null` if the connects times out
  static Future<Response> signUp({@required UserSignUp user}) async {
    final String signUpUri = Uri.encodeFull('$USERS_API_URL/users/sign_up');
    final String encodedUser = jsonEncode(user);

    try {
      return await post(signUpUri, body: encodedUser, headers: {
        "Content-Type": "application/json",
        "Origin": ADMIN_PORTAL_URL
      }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
    } catch (err) {
      print('Server connection timed out');
      print(err);
      return null;
    }
  }

  /// Extracts the `auth` cookie from [response] from the _set-cookie_ header
  ///
  /// The [response] object should contain a _set-cookie_ header
  ///
  /// Returns the `auth` section of the cookie or `null` if not found
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

  /// Saves the current user's [token] to a text file
  ///
  /// Returns the `File` that was saved locally or `null` if it was not possible to save the file
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

  /// Retrieves the current user's `token` from a text file that was previously saved through `saveToken`
  ///
  /// Returns the `token` present in the file or `null` if the file cannot be found or read
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

  /// Retrieves the current user's ID from their `token`, which was previously saved through `saveToken`
  ///
  /// A request is sent to /users/authenticate with the `token` in the headers in the process
  ///
  /// Returns the current user's ID or `null` if it was not possible to retrieve their `token`,
  /// the user could not be found or the connection timed out
  static Future<int> retrieveIdFromToken() async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final authResponse = await get(
            Uri.encodeFull('$USERS_API_URL/users/authenticate'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

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

  /// Authenticates the current user
  ///
  /// A request is sent to /users/authenticate with the `token` in the headers (retrieved locally)
  ///
  /// The current user's object is then retrieved by making another request to /users/id
  ///
  /// The current `user` object is returned if found. Otherwise, a "dummy" user object
  /// with ID = -1 is returned.
  ///
  /// This is a workaround to deal with `FutureBuilder` widgets used throughout the app
  static Future<User> authenticate() async {
    User nullUser = User(
        id: -1, username: null, email: null, givenName: null, userRole: null);

    try {
      // check for locally stored tokens before calling the API
      // final db = await getDb();

      //final localUser = db.query('users', )

      final localToken = await retrieveToken();

      if (localToken != null && localToken.isNotEmpty) {
        final authenticationUri =
            Uri.encodeFull('$USERS_API_URL/users/authenticate');

        try {
          final response = await get(authenticationUri, headers: {
            "Authorization": "Bearer $localToken",
            "Origin": ADMIN_PORTAL_URL
          }).timeout(Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
              onTimeout: () => null);

          if (response.statusCode == HttpStatus.ok) {
            final UserAuthenticate authenticatedUserData =
                UserAuthenticate.fromJson(jsonDecode(response.body));

            final userUri = Uri.encodeFull(
                '$USERS_API_URL/users/${authenticatedUserData.id}');

            final userResponse = await get(userUri, headers: {
              "Authorization": "Bearer $localToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
                onTimeout: () => null);

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

  /// Signs out the current user
  ///
  /// It simply deletes the file containing the current user's `token`
  /// so that they must sign in again
  static Future<void> signOut() async {
    // delete locally stored token file
    await _deleteToken();
  }
}
