class NotificationModel {
  String avatarUserPostUrl;
  //String relationship;
  String content;
  String postId;

  NotificationModel({this.avatarUserPostUrl, this.content, this.postId});

  NotificationModel.fromObject(dynamic o) {
    this.avatarUserPostUrl = o["avatarUserPostUrl"];
    //this.relationship = o["relationship"];
    this.content = o["content"];
    this.postId = o["postId"];
  }

  Map<String, dynamic> toJson() => {
        "avatarUserPostUrl": this.avatarUserPostUrl,
        //"relationship": this.relationship,
        "content": this.content,
        "postId": this.postId,
      };
}
