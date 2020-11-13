import 'package:app/services/base_service.dart';
import 'package:app/services/constants.dart';

/// Contains CRUD methods for /hair_lengths routes
class HairLengthService extends BaseService {
  static String hairLengthBaseUri =
      Uri.encodeFull('$USERS_API_URL/hair_lengths');

  HairLengthService() : super(HairLengthService.hairLengthBaseUri);
}
