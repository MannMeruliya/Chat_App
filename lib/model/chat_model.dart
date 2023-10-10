class Chat {

  late String image;
  late String name;
  late String about;
  late String id;
  late String isOnline;
  late String lastActive;
  late String createAt;
  late String pushToken;
  late String email;

  Chat({
    required this.image,
    required this.name,
    required this.about,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    required this.createAt,
    required this.pushToken,
    required this.email,
  });

  Chat.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '' ;
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    createAt = json['create_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['create_at'] = createAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}