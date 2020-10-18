import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HairColourService {
  static String hairColourBaseUri = Uri.encodeFull('$USERS_API_URL/colours');

  static Future<http.Response> getAll({String colourName}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        String uri = '$hairColourBaseUri';
        if (colourName != null) {
          uri += '?search=$colourName';
        }
        final response = await http.get(uri, headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair colour entries');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getById({@required int id}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$hairColourBaseUri/$id', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get hair colour entry');
      print(err);
      return null;
    }
  }
}
