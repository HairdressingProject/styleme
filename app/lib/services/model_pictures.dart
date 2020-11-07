import 'package:app/services/authentication.dart';
import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ModelPicturesService extends BaseService {
  static final String modelPicturesUri =
      Uri.encodeFull('$PICTURES_API_URL/models');

  ModelPicturesService() : super(ModelPicturesService.modelPicturesUri);

  Future<http.Response> getFileById({@required int modelPictureId}) async {
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

  @override
  Future<http.Response> getById(
      {@required int id, http.Client client, bool authenticate = true}) async {
    try {
      final userToken = await Authentication.retrieveToken();

      if (userToken != null && userToken.isNotEmpty) {
        final response = await http
            .get(Uri.encodeFull('$modelPicturesUri/id/$id'), headers: {
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
