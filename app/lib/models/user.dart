import 'package:app/models/base_model.dart';
import 'package:flutter/foundation.dart';

/// User model class
class User extends BaseModel {
  final int id;
  final String username;
  final String email;
  final String givenName;
  final String familyName;
  final String userRole;
  final String dateCreated;
  final String dateUpdated;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.givenName,
      this.familyName,
      @required this.userRole,
      this.dateCreated,
      this.dateUpdated})
      : super(id: id, dateCreated: dateCreated, dateUpdated: dateUpdated);

  @override
  String toString() {
    return '''User with ID: ${this.id}:
    Username: ${this.username}
    Email: ${this.email}
    Given name: ${this.givenName}
    Family name: ${this.familyName}
    User role: ${this.userRole}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['user_name'],
        email = json['user_email'],
        givenName = json['first_name'],
        familyName = json['last_name'],
        userRole = json['user_role'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'user_name': this.username,
        'user_email': this.email,
        'first_name': this.givenName,
        'last_name': this.familyName,
        'user_role': this.userRole,
        'date_created': dateCreated,
        'date_updated': dateUpdated
      };
}

/// Model class to be used in request bodies when signing in users
class UserSignIn {
  final String usernameOrEmail;
  final String password;

  const UserSignIn({@required this.usernameOrEmail, @required this.password});

  UserSignIn.fromJson(Map<String, String> json)
      : usernameOrEmail = json['user_name_or_email'],
        password = json['user_password'];

  Map<String, String> toJson() =>
      {'user_name_or_email': usernameOrEmail, 'user_password': password};

  @override
  String toString() {
    return '''UserSignIn:
    Username or email: ${this.usernameOrEmail}
    Password: ${this.password}
    ''';
  }
}

/// Model class to be used in request bodies when signing up users
class UserSignUp {
  final String username;
  final String email;
  final String password;
  final String givenName;
  final String familyName;

  const UserSignUp({
    @required this.username,
    @required this.email,
    @required this.givenName,
    @required this.familyName,
    @required this.password,
  });

  UserSignUp.fromJson(Map<String, String> json)
      : username = json['user_name'],
        email = json['user_email'],
        password = json['user_password'],
        givenName = json['first_name'],
        familyName = json['last_name'];

  Map<String, String> toJson() => {
        'user_name': username,
        'user_password': password,
        'user_email': email,
        'first_name': givenName,
        'last_name': familyName,
        'user_role': UserRoles.user
      };

  @override
  String toString() {
    return '''UserSignUp:
    Username: ${this.username}
    Email: ${this.email}
    Password: ${this.password}
    Given name: ${this.givenName}
    Family name: ${this.familyName}
    ''';
  }
}

/// Model class to be used in request bodies when updating user information
class UserUpdate {
  final String id;
  final String username;
  final String email;
  final String password;
  final String givenName;
  final String familyName;

  const UserUpdate({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.givenName,
    @required this.familyName,
    @required this.password,
  });

  UserUpdate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['user_name'],
        email = json['user_email'],
        password = json['user_password'],
        givenName = json['first_name'],
        familyName = json['last_name'];

  Map<String, String> toJson() => {
        'id': id,
        'user_name': username,
        'user_password': password,
        'user_email': email,
        'first_name': givenName,
        'last_name': familyName,
        'user_role': UserRoles.user
      };

  @override
  String toString() {
    return '''UserUpdate:
    Id: ${this.id}
    Username: ${this.username}
    Email: ${this.email}
    Password: ${this.password}
    Given name: ${this.givenName}
    Family name: ${this.familyName}
    ''';
  }
}

/// Model class to be used in request bodies when authenticating users
class UserAuthenticate {
  final int id;
  final String userRole;

  const UserAuthenticate({@required this.id, @required this.userRole});

  UserAuthenticate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userRole = json['user_role'];

  Map<String, dynamic> toJson() => {'id': id, 'user_role': userRole};

  @override
  String toString() {
    return '''UserAuthenticate:
    id: ${this.id}
    User role: ${this.userRole}
    ''';
  }
}

/// Base user roles
class UserRoles {
  static const admin = 'admin';
  static const user = 'user';
  static const dev = 'developer';
}

// LocalUser model for SQLite
class LocalUser {
  final int id;
  final String username;
  final String email;
  final String givenName;
  final String familyName;
  final String userRole;
  final String dateCreated;
  final String dateUpdated;
  String token;

  LocalUser(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.givenName,
      this.familyName,
      @required this.userRole,
      this.dateCreated,
      this.dateUpdated,
      this.token});

  @override
  String toString() {
    return '''Local user with ID: ${this.id}:
    Username: ${this.username}
    Email: ${this.email}
    Given name: ${this.givenName}
    Family name: ${this.familyName}
    User role: ${this.userRole}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    Token: $token
    ''';
  }

  LocalUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        token = json['token'],
        username = json['user_name'],
        email = json['user_email'],
        givenName = json['first_name'],
        familyName = json['last_name'],
        userRole = json['user_role'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'token': this.token,
        'user_name': this.username,
        'user_email': this.email,
        'first_name': this.givenName,
        'last_name': this.familyName,
        'user_role': this.userRole,
        'date_created': dateCreated,
        'date_updated': dateUpdated
      };
}
