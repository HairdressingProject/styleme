import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FaceShapeService {
  static String faceShapeBaseUri = Uri.encodeFull('$USERS_API_URL/face_shapes');

  static Future<http.Response> getAll({String faceShapeName}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        String uri = '$faceShapeBaseUri';
        if (faceShapeName != null) {
          uri += '?search=$faceShapeName';
        }
        final response = await http.get(uri, headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get face shape entries');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getById({@required int id}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$faceShapeBaseUri/$id', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get face shape entry');
      print(err);
      return null;
    }
  }
}
