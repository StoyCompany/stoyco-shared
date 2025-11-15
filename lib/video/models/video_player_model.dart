class VideoPlayerModel {
  VideoPlayerModel({
    this.id,
    this.appUrl,
    this.name,
    this.description,
    this.order,
    this.hasAccess,
    this.accessContent,
  });

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) =>
      VideoPlayerModel(
        id: json['id'],
        appUrl: json['appUrl'],
        name: json['name'],
        description: json['description'],
        order: json['order'],
        hasAccess: json['hasAccess'],
        accessContent: json['accessContent'],
      );
  String? id;
  String? appUrl;
  String? name;
  String? description;
  int? order;
  bool? hasAccess;
  Map<String, dynamic>? accessContent;

  Map<String, dynamic> toJson() => {
        'id': id,
        'appUrl': appUrl,
        'name': name,
        'description': description,
        'order': order,
        'hasAccess': hasAccess,
        'accessContent': accessContent,
      };
}
