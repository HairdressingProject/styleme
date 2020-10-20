import 'package:flutter/foundation.dart';

class HairStyle {
  final int id;
  final String hairStyleName;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  const HairStyle(
      {this.id,
      @required this.hairStyleName,
      this.label,
      this.dateCreated,
      this.dateUpdated});

  @override
  String toString() {
    return '''Hair style with ID: ${this.id}:
    Hair style name: ${this.hairStyleName}
    Label: ${this.label}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  HairStyle.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        hairStyleName = json['hairStyleName'],
        label = json['label'],
        dateCreated = json['dateCreated'],
        dateUpdated = json['dateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'HairStyleName': this.hairStyleName,
        'Label': this.label,
        'DateCreated': this.dateCreated,
        'DateUpdated': this.dateUpdated
      };
}
