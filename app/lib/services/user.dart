import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

/// Contains CRUD methods for /users routes
class UserService extends BaseService {
  static String usersUri = Uri.encodeFull('$USERS_API_URL/users');

  UserService() : super(UserService.usersUri);
}
