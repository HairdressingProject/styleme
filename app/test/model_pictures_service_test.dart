import 'dart:convert';
import 'dart:typed_data';

import 'package:app/models/model_picture.dart';
import 'package:app/services/model_pictures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

class MockModelPicturesService extends Mock implements ModelPicturesService {}

main() {
  group('getFileById', () {
    test(
        'returns a picture file after calling ModelPicturesService.getByFileId',
        () async {
      final client = MockClient();
      final mockedService = MockModelPicturesService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      // Pretend that the mocked response below contains an image file, with some bytes in its body
      final body = 'some bytes here';
      when(mockedService.getFileById(
              client: client, authenticate: false, modelPictureId: 1))
          .thenAnswer((_) async => http.Response(body, 200, headers: {
                "content-type": "image/jpeg",
                "content-length": body.length.toString()
              }));

      var results = await mockedService.getFileById(
          client: client, authenticate: false, modelPictureId: 1);

      var statusCode = results.statusCode;
      var headers = results.headers;

      expect(statusCode, 200);
      expect(headers, isA<Map<String, String>>());
      expect(headers['content-type'], 'image/jpeg');
      expect(headers['content-length'], body.length.toString());
    });
  });

  group('getById', () {
    test(
        'returns model picture object after calling ModelPicturesService.getById',
        () async {
      final client = MockClient();
      final mockedService = MockModelPicturesService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(mockedService.getById(client: client, authenticate: false, id: 1))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                "id": 1,
                "file_name": "394a649b43fba642954e1657cde70cd2.jpg",
                "file_path": "pictures/model_pictures/",
                "file_size": 54746,
                "height": 778,
                "width": 550,
                "hair_style_id": 1,
                "hair_length_id": 3,
                "face_shape_id": 1,
                "hair_colour_id": null,
                "date_created": "2020-11-13T02:14:46",
                "date_updated": "2020-11-13T02:14:46"
              }),
              200));

      var results = await mockedService.getById(
          client: client, authenticate: false, id: 1);

      var decodedResults = jsonDecode(results.body);
      var modelPicture = ModelPicture.fromJson(decodedResults);

      expect(modelPicture, isA<ModelPicture>());
      expect(modelPicture.id, 1);
      expect(modelPicture.fileName, '394a649b43fba642954e1657cde70cd2.jpg');
    });
  });
}
