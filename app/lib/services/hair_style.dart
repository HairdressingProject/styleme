import 'package:app/services/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class HairStyleService {
  static String hairStyleBaseUri = Uri.encodeFull('$USERS_API_URL/hair_styles');

  static Future<http.Response> getAll({String hairStyleName}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        String uri = '$hairStyleBaseUri';
        if (hairStyleName != null) {
          uri += '?search=$hairStyleName';
        }
        final response = await http.get(uri, headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair style entries');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getById({@required int id}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$hairStyleBaseUri/$id', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair style entry');
      print(err);
      return null;
    }
  }
}
