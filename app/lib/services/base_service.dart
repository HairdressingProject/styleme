import 'dart:convert';

import 'package:app/models/base_model.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/db.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

/// Base service class with methods common to all other services
abstract class BaseService {
  /// Base URI that corresponds to the routes related to this service
  final String baseUri;
  final String tableName;

  BaseService({@required this.baseUri, @required this.tableName});

  /// Retrieves all resources related to this service (locally)
  ///
  /// [skip] and [limit] can be passed to OFFSET and LIMIT the select query, respectively
  ///
  /// Returns a raw list of mapped items from the database.
  ///
  /// It is the caller's responsibility to parse each item in a suitable form.
  Future<List<Map<String, dynamic>>> getAllLocal(
      {int skip = 0, int limit = 1000}) async {
    final db = await getDb();

    final items = await db.query(tableName, offset: skip, limit: limit);

    return items;
  }

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

  /// Retrieves a resource related to this service by its [id] (locally)
  ///
  /// Returns a raw item map from the database or null if not found.
  ///
  /// It is the caller's responsibility to parse the item in a suitable form.
  Future<Map<String, dynamic>> getByIdLocal({@required int id}) async {
    final db = await getDb();

    final items = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (items.isNotEmpty) {
      return items[0];
    }
    return null;
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

  /// Updates a resource [obj] related to this service in the local database.
  ///
  /// [obj] should be a mappped representation of such item as a `Map<String, dynamic>`.
  ///
  /// For instance, your [obj] might be `Item.toJson()`.
  ///
  /// Returns the number of rows affected by the UPDATE statement.
  Future<int> putLocal({@required dynamic obj}) async {
    final db = await getDb();

    final rowsAffected =
        await db.update(tableName, obj, where: 'id = ?', whereArgs: [obj.id]);

    return rowsAffected;
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

  /// Deletes a resource related to this service from the local database
  ///  (identified by its [id])
  ///
  /// Returns the number of rows affected by the DELETE statement.
  Future<int> deleteLocal({@required int id}) async {
    final db = await getDb();

    final affectedRows =
        await db.delete(tableName, where: 'id = ?', whereArgs: [id]);

    return affectedRows;
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

  /// Inserts a new item related to this service into the local database.
  ///
  /// [obj] should be a mappped representation of such item as a `Map<String, dynamic>`.
  ///
  /// For instance, your [obj] might be `Item.toJson()`.
  ///
  /// Returns the number of rows affected by the INSERT statement.
  Future<int> postLocal({@required dynamic obj}) async {
    final db = await getDb();

    final rowsAffected = await db.insert(tableName, obj,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return rowsAffected;
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
