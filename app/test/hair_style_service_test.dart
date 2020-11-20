import 'dart:convert';

import 'package:app/models/hair_style.dart';
import 'package:app/services/hair_style.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

class MockHairStyleService extends Mock implements HairStyleService {}

main() {
  group('getAll', () {
    test('returns all hair styles after calling HairStyleService.getAll',
        () async {
      final client = MockClient();
      final mockedService = MockHairStyleService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockedService.getAll(client: client, authenticate: false))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "hair_styles": [
                  {
                    "id": 1,
                    "hair_style_name": "curly",
                    "label": "Curly",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 2,
                    "hair_style_name": "wavy",
                    "label": "Wavy",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 3,
                    "hair_style_name": "side_swept",
                    "label": "Side swept",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 4,
                    "hair_style_name": "pixie_cut",
                    "label": "Pixie cut",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 5,
                    "hair_style_name": "side_swept_bangs",
                    "label": "Side swept bangs",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 6,
                    "hair_style_name": "side_swept_braided",
                    "label": "Side swept braided",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "hair_style_links": [],
                    "history": [],
                    "model_pictures": []
                  }
                ]
              }),
              200));

      var results =
          await mockedService.getAll(client: client, authenticate: false);

      var decodedResults = jsonDecode(results.body)['hair_styles'];
      var hairStyles =
          List.from(decodedResults).map((e) => HairStyle.fromJson(e)).toList();

      expect(hairStyles, isNotEmpty);
      expect(hairStyles, isA<List<HairStyle>>());
      expect(hairStyles[0].hairStyleName, 'curly');
    });
  });
}
