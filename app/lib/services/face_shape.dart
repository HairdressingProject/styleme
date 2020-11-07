import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

class FaceShapeService extends BaseService {
  static String faceShapeBaseUri = Uri.encodeFull('$USERS_API_URL/face_shapes');

  FaceShapeService() : super(FaceShapeService.faceShapeBaseUri);
}
