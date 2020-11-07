import 'dart:convert';

import 'package:app/models/face_shape.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:app/services/face_shape.dart';

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

class MockFaceShapesService extends Mock implements FaceShapeService {}

main() {
  group('getAllFaceShapes', () {
    test('returns all face shapes after calling FaceShapeService.getAll',
        () async {
      final client = MockClient();
      final mockedService = MockFaceShapesService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockedService.getAll(client: client, authenticate: false))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "face_shapes": [
                  {
                    "id": 1,
                    "shape_name": "heart",
                    "label": "Heart",
                    "date_created": "2020-11-04T09:54:55",
                    "date_updated": null,
                    "face_shape_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 2,
                    "shape_name": "square",
                    "label": "Square",
                    "date_created": "2020-11-04T09:54:55",
                    "date_updated": null,
                    "face_shape_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 3,
                    "shape_name": "round",
                    "label": "Round",
                    "date_created": "2020-11-04T09:54:55",
                    "date_updated": null,
                    "face_shape_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 4,
                    "shape_name": "oval",
                    "label": "Oval",
                    "date_created": "2020-11-04T09:54:55",
                    "date_updated": null,
                    "face_shape_links": [],
                    "history": [],
                    "model_pictures": []
                  },
                  {
                    "id": 5,
                    "shape_name": "long",
                    "label": "Long",
                    "date_created": "2020-11-04T09:54:55",
                    "date_updated": null,
                    "face_shape_links": [],
                    "history": [],
                    "model_pictures": []
                  }
                ]
              }),
              200));

      var results =
          await mockedService.getAll(client: client, authenticate: false);

      var decodedResults = jsonDecode(results.body)['face_shapes'];
      var faceShapes =
          List.from(decodedResults).map((e) => FaceShape.fromJson(e)).toList();

      expect(faceShapes, isNotEmpty);
      expect(faceShapes, isA<List<FaceShape>>());
      expect(faceShapes[0].shapeName, 'heart');
    });
  });
}
