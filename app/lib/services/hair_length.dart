import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HairLengthService {
  static String hairLengthBaseUri =
      Uri.encodeFull('$USERS_API_URL/hair_lengths');

  static Future<http.Response> getAll({String hairLengthName}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        String uri = '$hairLengthBaseUri';
        if (hairLengthName != null) {
          uri += '?search=$hairLengthName';
        }
        final response = await http.get(uri, headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair length entries');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getById({@required int id}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$hairLengthBaseUri/$id', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair length entry');
      print(err);
      return null;
    }
  }
}
