import 'dart:async';
import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
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

  /// Extracts the `auth` token from [response] from the _X-Authorization-Token_ header
  ///
  /// The [response] object should contain an _X-Authorization_ header
  ///
  /// Returns the `auth` token or `null` if not found
  static String getAuthToken({@required Response response}) {
    final String token = response.headers['X-Authorization-Token'];

    return token;
  }

  /// Saves the current [user] and their [token] to the local database.
  ///
  /// If another user with the same ID already exists in the database,
  /// it is replaced by the current one.
  static Future<void> saveToken(
      {@required String token, @required User user}) async {
    // save user with token locally

    final localUser = LocalUser(
        id: user.id,
        token: token,
        email: user.email,
        givenName: user.givenName,
        familyName: user.familyName,
        userRole: user.userRole,
        username: user.username,
        dateCreated: user.dateCreated,
        dateUpdated: user.dateUpdated);

    final userService = UserService();
    await userService.postLocal(obj: localUser.toJson());
  }

  /// Retrieves the current user's `token` from the local database.
  ///
  /// Returns the `token` present in the file or `null` if no local user is found.
  static Future<String> retrieveToken() async {
    final db = await getDb();

    // retrieve the first user available
    final localUserMap = await db.query('users', limit: 1);

    if (localUserMap.isNotEmpty) {
      final localUser = LocalUser.fromJson(localUserMap[0]);
      return localUser.token;
    }

    return null;
  }

  static Future<void> _deleteToken() async {
    final db = await getDb();

    // delete all local users
    await db.delete('users');
  }

  /// Retrieves the current user's ID from their `token`, which was previously
  /// saved through `saveToken`.
  ///
  /// Returns the current user's ID or `null` if no local user is found.
  static Future<int> retrieveIdFromToken() async {
    final db = await getDb();

    final localUsersMap = await db.query('users', limit: 1);

    if (localUsersMap.isNotEmpty) {
      final localUser = LocalUser.fromJson(localUsersMap[0]);
      return localUser.id;
    }

    // local users not found, user is not authenticated
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

    // check local users
    final db = await getDb();

    final localUsers = await db.query('users', limit: 1);

    if (localUsers.isNotEmpty) {
      final localUser = LocalUser.fromJson(localUsers[0]);
      return User(
          id: localUser.id,
          email: localUser.email,
          userRole: localUser.userRole,
          givenName: localUser.givenName,
          username: localUser.username,
          dateCreated: localUser.dateCreated,
          dateUpdated: localUser.dateUpdated,
          familyName: localUser.familyName);
    }

    // local users not found, user is not authenticated
    return nullUser;
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
