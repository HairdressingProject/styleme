import 'dart:io';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ModelPicturesService {
  static final String modelPicturesUri = Uri.encodeFull('$PICTURES_API_URL/models');

  static Future<http.Response> getAll(
    {int skip, int limit = 100, String search}) async {
      try {
        final response = await http
            .get(Uri.encodeFull(
                '$modelPicturesUri?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${search ?? ""}'))
            .timeout(const Duration(seconds: 10));
        return response;
      } catch (err) {
        print('Failed to get all model pictures');
        print(err);
        return null;
      }
  }
  
}