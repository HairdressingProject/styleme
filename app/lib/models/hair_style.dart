import 'package:app/models/base_model.dart';
import 'package:flutter/foundation.dart';

class HairStyle extends BaseModel {
  final int id;
  final String hairStyleName;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  HairStyle(
      {this.id,
      @required this.hairStyleName,
      this.label,
      this.dateCreated,
      this.dateUpdated})
      : super(id: id, dateCreated: dateCreated, dateUpdated: dateUpdated);

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
        hairStyleName = json['hair_style_name'],
        label = json['label'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'hair_style_name': this.hairStyleName,
        'label': this.label,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };
}
