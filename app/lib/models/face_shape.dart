import 'package:flutter/foundation.dart';

class FaceShape {
  final int id;
  final String shapeName;
  final String dateCreated;
  final String dateUpdated;

  const FaceShape(
      {this.id, @required this.shapeName, this.dateCreated, this.dateUpdated});

  @override
  String toString() {
    return '''Face shape with ID: ${this.id}:
    Shape name: ${this.shapeName}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  FaceShape.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shapeName = json['shapeName'],
        dateCreated = json['dateCreated'],
        dateUpdated = json['dateUpdated'];

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'ShapeName': this.shapeName,
        'DateCreated': this.dateCreated,
        'DateUpdated': this.dateUpdated
      };
}

class FaceShapes {
  static const heart = 'heart';
  static const square = 'square';
  static const rectangular = 'rectangular';
  static const diamond = 'diamond';
  static const triangular = 'triangular';
  static const inverted_triangular = 'inverted_triangular';
  static const round = 'round';
  static const oval = 'oval';
  static const oblong = 'long';
}
