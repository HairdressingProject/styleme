import 'package:flutter/foundation.dart';

class HairStyle {
  final int id;
  final String hairStyleName;
  final String dateCreated;
  final String dateUpdated;

  const HairStyle(
      {this.id,
      @required this.hairStyleName,
      this.dateCreated,
      this.dateUpdated});

  @override
  String toString() {
    return '''Hair style with ID: ${this.id}:
    Hair style name: ${this.hairStyleName}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  HairStyle.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        hairStyleName = json['hairStyleName'],
        dateCreated = json['DateCreated'],
        dateUpdated = json['DateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'HairStyleName': this.hairStyleName,
        'DateCreated': this.dateCreated,
        'DateUpdated': this.dateUpdated
      };
}
