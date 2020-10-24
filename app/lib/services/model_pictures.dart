import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ModelPicturesService {
  static final String modelPicturesUri =
      Uri.encodeFull('$PICTURES_API_URL/models');

  static Future<http.Response> getAll(
      {int skip, int limit = 100, String search}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull(
                '$modelPicturesUri?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${search ?? ""}'),
            headers: {
              "Origin": ADMIN_PORTAL_URL,
              "Authorization": "Bearer $userToken"
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get all model pictures');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getFileById(
      {@required int modelPictureId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull('$modelPicturesUri/file/$modelPictureId'),
            headers: {
              "Origin": ADMIN_PORTAL_URL,
              "Authorization": "Bearer $userToken"
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get model picture file by id');
      print(err);
      return null;
    }
  }

  static Future<http.Response> getById({@required int modelPictureId}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http.get(
            Uri.encodeFull('$modelPicturesUri/id/$modelPictureId'),
            headers: {
              "Origin": ADMIN_PORTAL_URL,
              "Authorization": "Bearer $userToken"
            }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
        return response;
      }
      return null;
    } catch (err) {
      print('Failed to get model picture by id');
      print(err);
      return null;
    }
  }
}
