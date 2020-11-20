import 'dart:convert';

import 'package:app/models/hair_colour.dart';
import 'package:app/services/hair_colour.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

class MockHairColourService extends Mock implements HairColourService {}

main() {
  group('getAll', () {
    test('returns all hair colours after calling HairColourService.getAll',
        () async {
      final client = MockClient();
      final mockedService = MockHairColourService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockedService.getAll(client: client, authenticate: false))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "colours": [
                  {
                    "id": 1,
                    "colour_name": "sunny_yellow",
                    "colour_hash": "#F9E726",
                    "label": "Sunny yellow",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 2,
                    "colour_name": "juicy_orange",
                    "colour_hash": "#EC6126",
                    "label": "Juicy orange",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 3,
                    "colour_name": "fiery_red",
                    "colour_hash": "#B80C44",
                    "label": "Fiery red",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 4,
                    "colour_name": "hot_pink",
                    "colour_hash": "#CF34B1",
                    "label": "Hot pink",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 5,
                    "colour_name": "mysterious_violet",
                    "colour_hash": "#402D87",
                    "label": "Mysterious violet",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 6,
                    "colour_name": "ocean_blue",
                    "colour_hash": "#013C7A",
                    "label": "Ocean blue",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 7,
                    "colour_name": "tropical_green",
                    "colour_hash": "#255638",
                    "label": "Tropical green",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 8,
                    "colour_name": "jet_black",
                    "colour_hash": "#27221C",
                    "label": "Jet black",
                    "date_created": "2020-11-13T01:17:57",
                    "date_updated": null,
                    "history": [],
                    "model_pictures": []
                  }
                ]
              }),
              200));

      var results =
          await mockedService.getAll(client: client, authenticate: false);

      var decodedResults = jsonDecode(results.body)['colours'];
      var hairColours =
          List.from(decodedResults).map((e) => HairColour.fromJson(e)).toList();

      expect(hairColours, isNotEmpty);
      expect(hairColours, isA<List<HairColour>>());
      expect(hairColours[0].colourName, 'sunny_yellow');
      expect(hairColours[0].colourHash, '#F9E726');
    });
  });
}
