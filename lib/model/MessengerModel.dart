class MessengerModel {
  String avatarUrl;
  String content;
  String uid;
  List<dynamic> imageUrl;

  MessengerModel({this.avatarUrl, this.uid, this.content, this.imageUrl});

  MessengerModel.fromObject(dynamic o) {
    this.imageUrl = o["imageUrl"];
    this.content = o["content"];
    this.uid = o["uid"];
    this.avatarUrl = o["avatarUrl"];
  }

  Map<String, dynamic> toJson() => {
        "avatarUrl": this.avatarUrl,
        "uid": this.uid,
        "content": this.content,
        "imageUrl": this.imageUrl,
      };
}
