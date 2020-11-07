import 'dart:convert';

import 'package:app/models/base_model.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BaseService {
  final String baseUri;

  BaseService(this.baseUri);

  Future<http.Response> getAll(
      {String resourceName,
      int skip,
      int limit,
      http.Client client,
      bool authenticate = true}) async {
    try {
      if (client == null) {
        client = http.Client();
      }

      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          String uri = '$baseUri';
          if (resourceName != null) {
            uri +=
                '?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${resourceName ?? ""}';
          }
          final response = await client.get(uri, headers: {
            "Authorization": "Bearer $userToken",
            "Origin": ADMIN_PORTAL_URL
          }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

          return response;
        }
      } else {
        String uri = '$baseUri';
        if (resourceName != null) {
          uri +=
              '?skip=${skip ?? 0}&limit=${limit ?? 1000}&search=${resourceName ?? ""}';
        }
        final response = await http.get(uri, headers: {
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not get all resources');
      print(err);
      return null;
    }
  }

  Future<http.Response> getById(
      {@required int id, http.Client client, bool authenticate = true}) async {
    if (client == null) {
      client = http.Client();
    }

    try {
      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          final response = await client.get('$baseUri/$id', headers: {
            "Authorization": "Bearer $userToken",
            "Origin": ADMIN_PORTAL_URL
          }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

          return response;
        }
      } else {
        final response = await client.get('$baseUri/$id', headers: {
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }

      return null;
    } catch (err) {
      print('Could not get resource by id');
      print(err);
      return null;
    }
  }

  Future<http.Response> put(
      {@required dynamic obj,
      http.Client client,
      bool authenticate = true}) async {
    try {
      if (client == null) {
        client = http.Client();
      }

      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          final response = await client
              .put('$baseUri/${obj.id}',
                  headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer $userToken",
                    "Origin": ADMIN_PORTAL_URL
                  },
                  body: jsonEncode(obj))
              .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));
          return response;
        }
      } else {
        final response = await client
            .put('$baseUri/${obj.id}',
                headers: {
                  "Content-Type": "application/json",
                  "Origin": ADMIN_PORTAL_URL
                },
                body: jsonEncode(obj))
            .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not PUT resource entry');
      print(err);
      return null;
    }
  }

  Future<http.Response> delete(
      {@required int resourceId, http.Client client, bool authenticate = true}) async {
    if (client == null) {
      client = http.Client();
    }

    try {
      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          final response = await client.delete('$baseUri/$resourceId',
              headers: {
                "Authorization": "Bearer $userToken",
                "Origin": ADMIN_PORTAL_URL
              }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

          return response;
        }
      } else {
        final response = await client.delete('$baseUri/$resourceId', headers: {
          "Origin": ADMIN_PORTAL_URL
        }).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }

      return null;
    } catch (err) {
      print('Could not DELETE resource entry');
      print(err);
      return null;
    }
  }

  Future<http.Response> post(
      {@required BaseModel resource,
      http.Client client,
      bool authenticate}) async {
    if (client == null) {
      client = http.Client();
    }

    try {
      if (authenticate) {
        final userToken = await Authentication.retrieveToken();

        if (userToken != null && userToken.isNotEmpty) {
          final response = await http
              .post('$baseUri',
                  headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer $userToken",
                    "Origin": ADMIN_PORTAL_URL
                  },
                  body: jsonEncode(resource.toJson()))
              .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

          return response;
        }
      } else {
        final response = await http
            .post('$baseUri',
                headers: {
                  "Content-Type": "application/json",
                  "Origin": ADMIN_PORTAL_URL
                },
                body: jsonEncode(resource.toJson()))
            .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS));

        return response;
      }
      return null;
    } catch (err) {
      print('Could not post resource entry');
      print(err);
      return null;
    }
  }
}
