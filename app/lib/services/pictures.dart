import 'dart:io';
import 'package:app/services/constants.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PicturesService {
  static final String picturesUri =
      Uri.encodeFull('$PICTURES_API_URL/pictures');

  static Future<http.StreamedResponse> upload({@required File picture}) async {
    final request = http.MultipartRequest('POST', Uri.parse(picturesUri));

    request.files.add(http.MultipartFile(
        'picture', picture.readAsBytes().asStream(), picture.lengthSync()));

    try {
      final response =
          await request.send().timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to upload picture');
      print(err);
      return null;
    }

    /* try {
      final response = await http.post(picturesUri,
          body: pictureBytes,
          headers: {
            "Content-Type": "multipart/form-data"
          }).timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to upload picture');
      print(err);
      return null;
    } */
  }

  static Future<http.Response> getById({@required int pictureId}) async {
    try {
      final response = await http
          .get(Uri.encodeFull('$picturesUri/$pictureId'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (err) {
      print('Failed to get picture by id');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getFileById({@required pictureId}) async {
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
}
