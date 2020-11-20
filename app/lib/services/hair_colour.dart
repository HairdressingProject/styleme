import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

/// Contains CRUD methods for /colours routes
class HairColourService extends BaseService {
  static String hairColourBaseUri = Uri.encodeFull('$USERS_API_URL/colours');

  HairColourService()
      : super(
            baseUri: HairColourService.hairColourBaseUri, tableName: 'colours');
}
