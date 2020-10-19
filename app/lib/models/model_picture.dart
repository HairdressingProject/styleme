class ModelPicture {
  final int id;
  final String fileName;
  final String filePath;
  final int fileSize;
  final int width;
  final int height;
  final int hairStyleId;
  final int hairLengthId;
  final int hairColourId;
  final int faceShapeId;
  final String dateCreated;
  final String dateUpdated;

  ModelPicture({this.id, this.fileName, this.filePath, this.fileSize, this.width, this.height, this.faceShapeId, this.hairLengthId, this.hairStyleId, this.hairColourId, this.dateCreated, this.dateUpdated});

  ModelPicture.fromJson(Map<String, dynamic> json):
    id = json['id'],
    fileName = json['file_name'],
    filePath = json['file_path'],
    fileSize = json['file_size'],
    width = json['width'],
    height = json['height'],
    faceShapeId = json['face_shape_id'],
    hairLengthId = json['hair_length_id'],
    hairStyleId = json['hair_style_id'],
    hairColourId = json['haor_colour_id'],
    dateCreated = json['date_created'],
    dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'file_name': this.fileName,
    'file_path': this.filePath,
    'file_size': this.fileSize,
    'width': this.width,
    'height': this.height,
    'face_shape_id': this.faceShapeId,
    'hair_length_id': this.hairLengthId,
    'hair_style_id': this.hairStyleId,
    'hair_colour_id': this.hairColourId,
    'date_created': this.dateCreated,
    'date_updated': this.dateUpdated
  };

  @override
  String toString() {
    return '''Picture with ID = ${this.id}:
    Filename: ${this.fileName}
    File path: ${this.filePath}
    File size: ${this.fileSize}
    Width: ${this.width}
    Height: ${this.height}
    Face shape ID: ${this.faceShapeId}
    Hair length ID: ${this.hairLengthId}
    Hair style ID: ${this.hairStyleId}
    Hair colour ID: ${this.hairColourId}
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }  

}