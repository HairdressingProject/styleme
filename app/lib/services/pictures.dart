import 'dart:io';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PicturesService {
  static final String picturesUri =
      Uri.encodeFull('$PICTURES_API_URL/pictures');

  static Future<http.StreamedResponse> upload({@required File picture}) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$PICTURES_API_URL/pictures'));

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

  static Future<http.Response> getById({@required int pictureId}) async {
    try {
      final response = await http
          .get(Uri.encodeFull('$picturesUri/id/$pictureId'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to get picture by id');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getFileById({@required int pictureId}) async {
    try {
      final response = await http
          .get(Uri.encodeFull('$picturesUri/file/$pictureId'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to get picture file by id');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getAll(
      {int skip, int limit = 100, String search}) async {
    try {
      final response = await http
          .get(Uri.encodeFull(
              '$picturesUri?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${search ?? ""}'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to get all pictures');
      print(err);
      return null;
    }
  }

  static Future<http.Response> changeHairColour(
      {int pictureId, String colourName}) async {
    try {
      final response = await http
          .post(Uri.encodeFull(
              '$picturesUri/$pictureId/hair_colour?colour=$colourName'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to colour hair');
      print(err);
      return null;
    }
  }

  static Future<http.Response> changeHairColourRGB(
      {int pictureId, String colourName, int r, int g, int b}) async {
    try {
      final response = await http
          .post(Uri.encodeFull(
              '$picturesUri/$pictureId/hair_colour2?colour=$colourName&r=$r&g=$g&b=$b'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to colour hair');
      print(err);
      return null;
    }
  }

  static Future<http.Response> changeHairStyle(
      {@required int userPictureId, @required int modelPictureId}) async {
    try {
      final response = await http
          .get(Uri.encodeFull(
              '$picturesUri/change_hair_style?user_picture_id=$userPictureId&model_picture_id=$modelPictureId'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to apply changes to hair colour');
      print(err);
      return null;
    }
  }
}
