class VideoPlayerModel {
  VideoPlayerModel({
    this.id,
    this.appUrl,
    this.name,
    this.description,
    this.order,
  });

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) =>
      VideoPlayerModel(
        id: json['id'],
        appUrl: json['appUrl'],
        name: json['name'],
        description: json['description'],
        order: json['order'],
      );
  String? id;
  String? appUrl;
  String? name;
  String? description;
  int? order;

  Map<String, dynamic> toJson() => {
        'id': id,
        'appUrl': appUrl,
        'name': name,
        'description': description,
        'order': order,
      };
}
