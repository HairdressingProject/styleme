import 'dart:convert';

import 'package:app/models/face_shape.dart';
import 'package:app/models/history.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  static String historyBaseUri = Uri.encodeFull('$PICTURES_API_URL/history');

  static Future<http.Response> getById({@required int historyId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$historyBaseUri/$historyId', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));
        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve history entry');
      print(err);
      return null;
    }
  }

  static Future<http.Response> put({@required History history}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .put('$historyBaseUri/${history.id}',
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $userToken",
                  "Origin": ADMIN_PORTAL_URL
                },
                body: history.toJson())
            .timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not PUT history entry');
      print(err);
      return null;
    }
  }

  static Future<http.Response> delete({@required int historyId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.delete('$historyBaseUri/$historyId',
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not DELETE history entry');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getByUserId({int userId}) async {
    var id = userId ?? await Authentication.retrieveIdFromToken();
    if (id == null) return null;

    final userToken = await Authentication.retrieveToken();
    if (userToken == null) return null;

    try {
      final historyResponse = await http.get('$historyBaseUri/users/$id',
          headers: {
            "Authorization": "Bearer $userToken",
            "Origin": ADMIN_PORTAL_URL
          });

      return historyResponse;
    } catch (err) {
      print('Failed to retrieve user history');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getByPictureFilename(
      {@required String filename}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.delete('$historyBaseUri/pictures/$filename',
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve history entries by picture filename');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getAllEntries() async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$historyBaseUri', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve all history entries');
      print(err);
      return null;
    }
  }

  static Future<http.Response> post({@required History history}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .post('$historyBaseUri',
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $userToken",
                  "Origin": ADMIN_PORTAL_URL
                },
                body: jsonEncode(history.toJson()))
            .timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not post history entry');
      print(err);
      return null;
    }
  }

  static Future<http.Response> postFaceShapeEntry(
      {@required HistoryAddFaceShape faceShapeEntry}) async {
    print('Sending this request body:');
    final body = faceShapeEntry.toJson();

    print(body);
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .post('$historyBaseUri/face_shape',
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $userToken",
                  "Origin": ADMIN_PORTAL_URL
                },
                body: jsonEncode(body),
                encoding: Encoding.getByName('utf-8'))
            .timeout(const Duration(seconds: 10));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not post face shape history entry');
      print(err);
      return null;
    }
  }
}
