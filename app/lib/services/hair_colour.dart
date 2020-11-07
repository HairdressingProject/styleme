import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

class HairColourService extends BaseService {
  static String hairColourBaseUri = Uri.encodeFull('$USERS_API_URL/colours');

  HairColourService() : super(HairColourService.hairColourBaseUri);
}
