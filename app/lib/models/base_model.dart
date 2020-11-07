class BaseModel {
  final int id;
  final String dateCreated;
  final String dateUpdated;

  BaseModel({this.id, this.dateCreated, this.dateUpdated});

  @override
  String toString() {
    return '''Base model object with id: ${this.id}:
    Date created: ${this.dateCreated}
    Date updated: ${this.dateUpdated}
    ''';
  }

  BaseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateCreated = json['date_created'],
        dateUpdated = json['date_updated'];

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'date_created': this.dateCreated,
        'date_updated': this.dateUpdated
      };
}
