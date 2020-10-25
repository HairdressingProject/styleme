import 'dart:async';
import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {
  static String usersUri = Uri.encodeFull('$USERS_API_URL/users');

  static Future<http.Response> update(
      {@required int userId, @required UserUpdate user}) async {
    try {
      final token = await Authentication.retrieveToken();
      final encodedUser = jsonEncode(user);

      if (token != null && token.isNotEmpty) {
        final response = await http
            .put('$usersUri/$userId',
                headers: {
                  "Content-Type": "application/json",
                  "Origin": ADMIN_PORTAL_URL,
                  "Authorization": "Bearer $token"
                },
                body: encodedUser)
            .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not update user');
      print(err);
    }
    return null;
  }
}
