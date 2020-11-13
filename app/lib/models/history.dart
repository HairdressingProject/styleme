import 'package:app/models/base_model.dart';
import 'package:flutter/foundation.dart';

/// History model class
class History extends BaseModel {
  final int id;
  final int pictureId;
  final int originalPictureId;
  final int previousPictureId;
  final int hairColourId;
  final int hairStyleId;
  final int faceShapeId;
  final int userId;
  final String dateCreated;
  final String dateUpdated;

  History(
      {this.id,
      this.pictureId,
      this.originalPictureId,
      this.previousPictureId,
      this.hairColourId,
      this.hairStyleId,
      this.faceShapeId,
      this.userId,
      this.dateCreated,
      this.dateUpdated})
      : super(id: id, dateCreated: dateCreated, dateUpdated: dateUpdated);

  @override
  String toString() {
    return '''History entry with ID: ${this.id}:
    Picture ID: ${this.pictureId}
    Original picture ID: ${this.originalPictureId}
    Previous picture ID: ${this.previousPictureId}
    Hair colour ID: ${this.hairColourId}
    Hair style ID: ${this.hairStyleId}
    Face shape ID: ${this.faceShapeId}
    User ID: ${this.userId}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  History.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pictureId = json['picture_id'],
        originalPictureId = json['original_picture_id'],
        previousPictureId = json['previous_picture_id'],
        hairColourId = json['hair_colour_id'],
        hairStyleId = json['hair_style_id'],
        faceShapeId = json['face_shape_id'],
        userId = json['user_id'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'picture_id': this.pictureId,
        'original_picture_id': this.originalPictureId,
        'previous_picture_id': this.previousPictureId,
        'hair_colour_id': this.hairColourId,
        'hair_style_id': this.hairStyleId,
        'face_shape_id': this.faceShapeId,
        'user_id': this.userId,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };

  @override
  bool operator ==(other) {
    return this.id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model class to be used in request bodies when adding a new history entry with
/// an updated face shape
class HistoryAddFaceShape {
  final int userId;
  final int faceShapeId;

  const HistoryAddFaceShape(
      {@required this.userId, @required this.faceShapeId});

  @override
  String toString() {
    return '''Adding face shape to history:
    User ID: ${this.userId}
    Face shape ID: ${this.faceShapeId}
    ''';
  }

  HistoryAddFaceShape.fromJson(Map<String, int> json)
      : userId = json['user_id'],
        faceShapeId = json['face_shape_id'];

  Map<String, int> toJson() =>
      {'user_id': this.userId, 'face_shape_id': this.faceShapeId};
}
