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
        hairLengthName = json['hair_length_name'],
        label = json['label'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'hair_length_name': this.hairLengthName,
        'label': this.label,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };
}
