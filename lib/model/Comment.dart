class Comment {
  String userName;
  String userAvatarUrl;
  String content;
  String imageUrl;

  Comment({this.content, this.userName, this.userAvatarUrl, this.imageUrl});

  Comment.fromObject(dynamic o) {
    this.userAvatarUrl = o["userAvatarUrl"];
    this.userName = o["userName"];
    this.content = o["content"];
    this.imageUrl = o["imageUrl"];
  }

  Map<String, dynamic> toJson() => {
        "userName": this.userName,
        "userAvatarUrl": this.userAvatarUrl,
        "content": this.content,
        "imageUrl": this.imageUrl,
      };
}
