import 'dart:convert';

import 'package:app/models/hair_length.dart';
import 'package:app/services/hair_length.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

class MockHairLengthService extends Mock implements HairLengthService {}

main() {
  group('getAll', () {
    test('returns all hair lengths after calling HairLengthService.getAll',
        () async {
      final client = MockClient();
      final mockedService = MockHairLengthService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockedService.getAll(client: client, authenticate: false))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "hair_lengths": [
                  {
                    "id": 1,
                    "hair_length_name": "short",
                    "label": "Short",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_length_links": [],
                    "model_pictures": []
                  },
                  {
                    "id": 2,
                    "hair_length_name": "medium",
                    "label": "Medium",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_length_links": [],
                    "model_pictures": []
                  },
                  {
                    "id": 3,
                    "hair_length_name": "long",
                    "label": "Long",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_length_links": [],
                    "model_pictures": []
                  }
                ]
              }),
              200));

      var results =
          await mockedService.getAll(client: client, authenticate: false);

      var decodedResults = jsonDecode(results.body)['hair_lengths'];
      var hairLengths =
          List.from(decodedResults).map((e) => HairLength.fromJson(e)).toList();

      expect(hairLengths, isNotEmpty);
      expect(hairLengths, isA<List<HairLength>>());
      expect(hairLengths[0].hairLengthName, 'short');
      expect(hairLengths[0].label, 'Short');
    });
  });
}
