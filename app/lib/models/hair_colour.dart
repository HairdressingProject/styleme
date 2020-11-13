import 'package:flutter/foundation.dart';

import 'base_model.dart';

/// Hair colour model class
class HairColour extends BaseModel {
  final int id;
  final String colourName;
  final String colourHash;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  HairColour(
      {this.id,
      @required this.colourName,
      @required this.colourHash,
      this.label,
      this.dateCreated,
      this.dateUpdated})
      : super(id: id, dateCreated: dateCreated, dateUpdated: dateUpdated);

  @override
  String toString() {
    return '''Hair colour with ID: ${this.id}:
    Colour name: ${this.colourName}
    Colour hash: ${this.colourHash}
    Label: ${this.label}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  HairColour.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        colourName = json['colour_name'],
        colourHash = json['colour_hash'],
        label = json['label'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'colour_name': this.colourName,
        'colour_hash': this.colourHash,
        'label': this.label,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };
}
