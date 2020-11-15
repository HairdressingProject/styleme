import 'package:app/services/authentication.dart';
import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Contains CRUD methods for /models routes
class ModelPicturesService extends BaseService {
  static final String modelPicturesUri =
      Uri.encodeFull('$PICTURES_API_URL/models');

  ModelPicturesService() : super(ModelPicturesService.modelPicturesUri);

  /// Retrieves a picture file from the backend (identified by its ID)
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` object is returned
  Future<http.Response> getFileById(
      {@required int modelPictureId,
      http.Client client,
      bool authenticate = true}) async {
    if (client == null) {
      client = http.Client();
    }

    try {
      if (authenticate) {
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
      } else {
        final response = await http.get(
            Uri.encodeFull('$modelPicturesUri/file/$modelPictureId'),
            headers: {
              "Origin": ADMIN_PORTAL_URL
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

  /// Retrieves a model picture object by its ID
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` object is returned
  @override
  Future<http.Response> getById(
      {@required int id, http.Client client, bool authenticate = true}) async {
    try {
      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          final response = await http
              .get(Uri.encodeFull('$modelPicturesUri/id/$id'), headers: {
            "Origin": ADMIN_PORTAL_URL,
            "Authorization": "Bearer $userToken"
          }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
          return response;
        }
      } else {
        final response = await http
            .get(Uri.encodeFull('$modelPicturesUri/id/$id'), headers: {
          "Origin": ADMIN_PORTAL_URL
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
