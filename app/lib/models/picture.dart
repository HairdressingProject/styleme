class Picture {
  final int id;
  final String fileName;
  final String filePath;
  final int fileSize;
  final int width;
  final int height;
  final String dateCreated;
  final String dateUpdated;

  Picture(this.id, this.fileName, this.filePath, this.fileSize, this.width,
      this.height, this.dateCreated, this.dateUpdated);

  Picture.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fileName = json['file_name'],
        filePath = json['file_path'],
        fileSize = json['file_size'],
        width = json['width'],
        height = json['height'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'file_name': this.fileName,
        'file_path': this.filePath,
        'file_size': this.fileSize,
        'width': this.width,
        'height': this.height,
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
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }
}
