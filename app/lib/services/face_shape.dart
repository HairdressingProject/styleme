import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

/// Contains CRUD methods for /face_shapes routes
class FaceShapeService extends BaseService {
  static String faceShapeBaseUri = Uri.encodeFull('$USERS_API_URL/face_shapes');

  FaceShapeService()
      : super(
            baseUri: FaceShapeService.faceShapeBaseUri,
            tableName: 'face_shapes');
}
