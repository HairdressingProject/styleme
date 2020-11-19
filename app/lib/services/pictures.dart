import 'dart:io';
import 'dart:typed_data';
import 'package:app/models/history.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/db.dart';
import 'package:app/services/history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Contains CRUD methods for /pictures routes
///
/// Also contains specific methods related to changing hair styles and hair colours
class PicturesService extends BaseService {
  static String picturesUri = Uri.encodeFull('$PICTURES_API_URL/pictures');
  String picturesCacheDir;

  PicturesService({String picturesCacheDir = 'pictures'})
      : super(baseUri: PicturesService.picturesUri, tableName: 'pictures');

  /// Uploads a [picture] file as `multipart/form-data`
  ///
  /// The `Response` sent by API is returned
  Future<http.StreamedResponse> upload({@required File picture}) async {
    final userToken = await Authentication.retrieveToken();

    if (userToken != null && userToken.isNotEmpty) {
      final request = http.MultipartRequest(
          'POST', Uri.parse('$PICTURES_API_URL/pictures'));

      request.headers['origin'] = ADMIN_PORTAL_URL;
      request.headers['authorization'] = "Bearer $userToken";

      request.files.add(http.MultipartFile(
          'file', picture.readAsBytes().asStream(), picture.lengthSync(),
          filename: picture.path.split('/').last));

      try {
        final response =
            await request.send().timeout(const Duration(seconds: 60));
        return response;
      } catch (err) {
        print('Failed to upload picture');
        print(err);
        return null;
      }
    }
    return null;
  }

  /// Retrieves a `Picture` object by its ID
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
  @override
  Future<http.Response> getById(
      {@required int id, http.Client client, bool authenticate = true}) async {
    if (client == null) {
      client = http.Client();
    }

    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await client.get(Uri.encodeFull('$picturesUri/id/$id'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get picture by id');
      print(err);
      return null;
    }
  }

  /// Retrieves a `Picture` file by its ID
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> getFileById({@required int pictureId}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .get(Uri.encodeFull('$picturesUri/file/$pictureId'), headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get picture file by id');
      print(err);
      return null;
    }
  }

  Future<http.Response> getLatestFileByUserId({@required int userId}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .get(Uri.encodeFull('$picturesUri/users/$userId/latest'), headers: {
          "Authorization": "Bearer $userToken",
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get latest picture file by id');
      print(err);
      return null;
    }
  }

  /// Changes hair colour in a picture identified by its [pictureId]
  ///
  /// [colourName] must be one of the pre-defined base colours available in the database
  ///
  /// Prefer using `changeHairColourRGB` instead of this method
  ///
  /// The `Response` sent by API is returned
  @deprecated
  Future<http.Response> changeHairColour(
      {int pictureId, String colourName}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.post(
            Uri.encodeFull(
                '$picturesUri/$pictureId/hair_colour?colour=$colourName'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to colour hair');
      print(err);
      return null;
    }
  }

  /// Changes hair colour in a picture identified by its [pictureId]
  ///
  /// [colourName] must be one of the pre-defined base colours available in the database
  ///
  /// [r], [g], [b] values specify the exact colour to be used
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> changeHairColourRGB(
      {int pictureId, String colourName, int r, int g, int b}) async {
    final userToken = await Authentication.retrieveToken();
    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull(
                '$picturesUri/change_hair_colour/$pictureId?colour=$colourName&r=$r&g=$g&b=$b'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to colour hair');
      print(err);
      return null;
    }
  }

  /// Changes hair style in a picture identified by its [userPictureId]
  ///
  /// [modelPictureId] must correspond to one of the pre-defined model pictures registered in the database
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> changeHairStyle(
      {@required int userPictureId, @required int modelPictureId}) async {
    final userToken = await Authentication.retrieveToken();
    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull(
                '$picturesUri/change_hair_style?user_picture_id=$userPictureId&model_picture_id=$modelPictureId'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to apply changes to hair colour');
      print(err);
      return null;
    }
  }

  Future<void> discardChangesLocal({@required int originalPictureId}) async {
    final db = await getDb();

    // get all history entries associated with pictureId
    final associatedEntries = await db.query('history',
        where: 'NOT picture_id = ?', whereArgs: [originalPictureId]);

    if (associatedEntries.isNotEmpty) {
      final historyService = HistoryService();

      for (var rawEntry in associatedEntries) {
        final entry = History.fromJson(rawEntry);
        await this.deleteLocal(id: entry.pictureId);
        await historyService.deleteLocal(id: entry.id);
      }
    }
  }

  Future<http.Response> discardChanges(
      {@required int originalPictureId}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.delete(
            Uri.encodeFull('$picturesUri/discard_changes/$originalPictureId'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
    } catch (err) {
      print('Failed to discard changes');
      print(err);
      return null;
    }
    return null;
  }
}
