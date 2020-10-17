import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String givenName;
  final String familyName;
  final String userRole;
  final String dateCreated;
  final String dateUpdated;

  const User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.givenName,
      this.familyName,
      @required this.userRole,
      this.dateCreated,
      this.dateUpdated});

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
        username = json['userName'],
        email = json['userEmail'],
        givenName = json['firstName'],
        familyName = json['lastName'],
        userRole = json['userRole'],
        dateCreated = json['dateCreated'],
        dateUpdated = json['dateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'UserName': this.username,
        'UserEmail': this.email,
        'FirstName': this.givenName,
        'LastName': this.familyName,
        'UserRole': this.userRole,
        'DateCreated': dateCreated,
        'DateUpdated': dateUpdated
      };
}

class UserSignIn {
  final String usernameOrEmail;
  final String password;

  const UserSignIn({@required this.usernameOrEmail, @required this.password});

  UserSignIn.fromJson(Map<String, String> json)
      : usernameOrEmail = json['UserNameOrEmail'],
        password = json['UserPassword'];

  Map<String, String> toJson() =>
      {'UserNameOrEmail': usernameOrEmail, 'UserPassword': password};

  @override
  String toString() {
    return '''UserSignIn:
    Username or email: ${this.usernameOrEmail}
    Password: ${this.password}
    ''';
  }
}

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
      : username = json['UserName'],
        email = json['UserEmail'],
        password = json['UserPassword'],
        givenName = json['FirstName'],
        familyName = json['LastName'];

  Map<String, String> toJson() => {
        'UserName': username,
        'UserPassword': password,
        'UserEmail': email,
        'FirstName': givenName,
        'LastName': familyName,
        'UserRole': UserRoles.user
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

class UserAuthenticate {
  final int id;
  final String userRole;

  const UserAuthenticate({@required this.id, @required this.userRole});

  UserAuthenticate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userRole = json['userRole'];

  Map<String, dynamic> toJson() => {'Id': id, 'UserRole': userRole};

  @override
  String toString() {
    return '''UserAuthenticate:
    id: ${this.id}
    User role: ${this.userRole}
    ''';
  }
}

class UserRoles {
  static const admin = 'admin';
  static const user = 'user';
  static const dev = 'developer';
}
