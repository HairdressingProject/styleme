import 'dart:convert';

import 'package:app/models/history.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Contains CRUD methods for /history routes for the current user
class HistoryService extends BaseService {
  static String historyBaseUri = Uri.encodeFull('$PICTURES_API_URL/history');

  HistoryService() : super(HistoryService.historyBaseUri);

  /// Retrieves a `User` object identified by its ID
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> getByUserId({@required int userId}) async {
    var id = userId ?? await Authentication.retrieveIdFromToken();
    if (id == null) return null;

    final userToken = await Authentication.retrieveToken();
    if (userToken == null) return null;

    try {
      final historyResponse = await http.get('$historyBaseUri/users/$id',
          headers: {
            "Authorization": "Bearer $userToken",
            "Origin": ADMIN_PORTAL_URL
          }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

      return historyResponse;
    } catch (err) {
      print('Failed to retrieve user history');
      print(err);
      return null;
    }
  }

  /// Retrieves a picture identified by its [filename]
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> getByPictureFilename(
      {@required String filename}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$historyBaseUri/pictures/$filename',
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve history entries by picture filename');
      print(err);
      return null;
    }
  }

  /// Retrieves all history entries associated with the current `User`
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> getAllEntries() async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$historyBaseUri', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve all history entries');
      print(err);
      return null;
    }
  }

  Future<http.Response> getLatestUserHistoryEntry(
      {@required int userId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get('$historyBaseUri/users/$userId/latest',
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not latest user history entry');
      print(err);
      return null;
    }
  }

  /// Adds a new history entry with an updated [faceShapeEntry]
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> postFaceShapeEntry(
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
            .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

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
