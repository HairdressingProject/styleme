import 'package:app/services/base_service.dart';

import 'constants.dart';

class HairStyleService extends BaseService {
  static String hairStyleBaseUri = Uri.encodeFull('$USERS_API_URL/hair_styles');

  HairStyleService() : super(HairStyleService.hairStyleBaseUri);
}
