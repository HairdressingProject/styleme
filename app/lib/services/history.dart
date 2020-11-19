import 'dart:convert';

import 'package:app/models/history.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/db.dart';

/// Contains CRUD methods for /history routes for the current user
class HistoryService extends BaseService {
  static String historyBaseUri = Uri.encodeFull('$PICTURES_API_URL/history');

  HistoryService()
      : super(baseUri: HistoryService.historyBaseUri, tableName: 'history');

  /// Retrieves local history records associated with this [userId].
  Future<List<History>> getByUserIdLocal({@required int userId}) async {
    final db = await getDb();
    List<History> userHistory = List<History>();

    final localHistoryMap =
        await db.query(tableName, where: 'user_id = ?', whereArgs: [userId]);

    if (localHistoryMap.isNotEmpty) {
      userHistory = localHistoryMap.map((e) => History.fromJson(e)).toList();
    }

    return userHistory;
  }

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

  /// Retrieves all history records (locally) associated with this [originalPictureId]
  Future<List<History>> getByPictureIdLocal(
      {@required int originalPictureId}) async {
    final db = await getDb();

    final localHistoryMap = await db.query(tableName,
        where: 'original_picture_id = ?', whereArgs: [originalPictureId]);

    final history = localHistoryMap.map((e) => History.fromJson(e)).toList();

    return history;
  }

  /// Retrieves all history records (from the API) associated with this [originalPictureId]
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> getByPictureId(
      {@required int originalPictureId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .get('$historyBaseUri/pictures/id/$originalPictureId', headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not retrieve history entries by picture id');
      print(err);
      return null;
    }
  }

  /// Retrieves history records of the picture associated with this [filename]
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

  /// Retrieves the latest user history entry (locally) identified by [userId].
  ///
  /// Returns the latest `History` entry or null if not found.
  Future<History> getLatestUserHistoryEntryLocal({@required int userId}) async {
    final db = await getDb();

    final latestEntryList = await db.query(tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'id DESC',
        limit: 1);

    if (latestEntryList.isNotEmpty) {
      final latestEntry = History.fromJson(latestEntryList[0]);
      return latestEntry;
    }

    return null;
  }

  /// Retrieves the latest user history entry (from the API) identified by [userId].
  ///
  /// Returns the `Response` from the API or null if the request fails.
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
    final body = faceShapeEntry.toJson();
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
