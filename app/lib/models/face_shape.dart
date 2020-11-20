import 'package:app/models/base_model.dart';
import 'package:flutter/foundation.dart';

/// Face shape model class
class FaceShape extends BaseModel {
  final int id;
  final String shapeName;
  final String label;
  final String dateCreated;
  final String dateUpdated;

  FaceShape(
      {this.id,
      @required this.shapeName,
      this.label,
      this.dateCreated,
      this.dateUpdated})
      : super(id: id, dateCreated: dateCreated, dateUpdated: dateUpdated);

  @override
  String toString() {
    return '''Face shape with ID: ${this.id}:
    Shape name: ${this.shapeName}
    Label: ${this.label}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  FaceShape.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shapeName = json['shape_name'],
        label = json['label'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'shape_name': this.shapeName,
        'label': this.label,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };
}

class AddFaceShapeHistoryEntry {
  final int userId;
  final int faceShapeId;

  const AddFaceShapeHistoryEntry(
      {@required this.userId, @required this.faceShapeId});

  @override
  String toString() {
    return '''Face shape history entry:
    Face shape ID: $faceShapeId
    User ID: $userId
    ''';
  }

  AddFaceShapeHistoryEntry.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        faceShapeId = json['face_shape_id'];

  Map<String, dynamic> toJson() =>
      {'face_shape_id': this.faceShapeId, 'user_id': this.userId};
}
