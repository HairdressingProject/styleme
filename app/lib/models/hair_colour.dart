import 'package:flutter/foundation.dart';

class HairColour {
  final int id;
  final String colourName;
  final String colourHash;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  const HairColour(
      {this.id,
      @required this.colourName,
      @required this.colourHash,
      this.label,
      this.dateCreated,
      this.dateUpdated});

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
        colourName = json['colourName'],
        colourHash = json['colourHash'],
        label = json['label'],
        dateCreated = json['dateCreated'],
        dateUpdated = json['dateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'ColourName': this.colourName,
        'ColourHash': this.colourHash,
        'Label': this.label,
        'DateCreated': this.dateCreated,
        'DateUpdated': this.dateUpdated
      };
}
