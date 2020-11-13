import 'dart:convert';

import 'package:app/models/base_model.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Base service class with methods common to all other services
class BaseService {
  /// Base URI that corresponds to the routes related to this service
  final String baseUri;

  BaseService(this.baseUri);

  /// Retrieves all resources related to this service
  ///
  /// [resourceName], [skip] and [limit] are appended as optional query parameters
  /// when filtering results
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
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

  /// Retrieves a resource related to this service by its [id]
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
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

  /// Updates a resource [obj] related to this service by sending a PUT request
  /// to the appropriate route
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
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

  /// Deletes a resource related to this service (identified by its [resourceId])
  /// by sending a DELETE request to the appropriate route
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
  Future<http.Response> delete(
      {@required int resourceId,
      http.Client client,
      bool authenticate = true}) async {
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

  /// Creates a new [resource] related to this service by sending a POST request
  /// to the appropriate route
  ///
  /// An optional [client] object may also be used (useful for mocking)
  ///
  /// This method sends authentication headers in the requests by default,
  /// which can be changed by setting [authenticate] to `false`
  ///
  /// The `Response` sent by API is returned
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
