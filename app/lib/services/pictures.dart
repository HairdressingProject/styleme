import 'dart:io';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PicturesService {
  static final String picturesUri =
      Uri.encodeFull('$PICTURES_API_URL/pictures');

  static Future<http.StreamedResponse> upload({@required File picture}) async {
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

  static Future<http.Response> getById({@required int pictureId}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .get(Uri.encodeFull('$picturesUri/id/$pictureId'), headers: {
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

  static Future<http.Response> getFileById({@required int pictureId}) async {
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

  static Future<http.Response> getAll(
      {int skip, int limit = 100, String search}) async {
    final userToken = await Authentication.retrieveToken();

    try {
      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull(
                '$picturesUri?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${search ?? ""}'),
            headers: {
              "Authorization": "Bearer $userToken",
              "Origin": ADMIN_PORTAL_URL
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get all pictures');
      print(err);
      return null;
    }
  }

  static Future<http.Response> changeHairColour(
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

  static Future<http.Response> changeHairColourRGB(
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

  static Future<http.Response> changeHairStyle(
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
}
