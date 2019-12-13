class PostID {
  List<dynamic> postIds;

  PostID({this.postIds});

  PostID.fromObject(dynamic o) {
    this.postIds = o["postIds"];
  }

  Map<String, dynamic> toJson() => {
        "postIds": this.postIds,
      };
}
