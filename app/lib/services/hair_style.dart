import 'package:app/services/base_service.dart';

import 'constants.dart';

/// Contains CRUD methods for /hair_styles routes
class HairStyleService extends BaseService {
  static String hairStyleBaseUri = Uri.encodeFull('$USERS_API_URL/hair_styles');

  HairStyleService()
      : super(
            baseUri: HairStyleService.hairStyleBaseUri,
            tableName: 'hair_styles');
}
