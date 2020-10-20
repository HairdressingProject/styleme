import 'package:flutter/foundation.dart';

class HairLength {
  final int id;
  final String hairLengthName;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  const HairLength(
      {this.id,
      @required this.hairLengthName,
      this.label,
      this.dateCreated,
      this.dateUpdated});

  @override
  String toString() {
    return '''Hair length with ID: ${this.id}:
    Length name: ${this.hairLengthName}
    Label: ${this.label}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  HairLength.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        hairLengthName = json['hairLengthName'],
        label = json['label'],
        dateCreated = json['dateCreated'],
        dateUpdated = json['dateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'HairLengthName': this.hairLengthName,
        'Label': this.label,
        'DateCreated': this.dateCreated,
        'DateUpdated': this.dateUpdated
      };
}
