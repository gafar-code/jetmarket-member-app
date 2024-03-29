class CreateChatModel {
  int? id;
  bool? isClosed;
  String? image;
  String? name;
  String? createdAt;
  String? message;
  int? unreadCount;

  CreateChatModel(
      {this.id,
      this.isClosed,
      this.image,
      this.name,
      this.createdAt,
      this.message,
      this.unreadCount});

  CreateChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isClosed = json['is_closed'];
    image = json['image'];
    name = json['name'];
    createdAt = json['created_at'];
    message = json['message'];
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_closed'] = isClosed;
    data['image'] = image;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['message'] = message;
    data['unread_count'] = unreadCount;
    return data;
  }
}
