class Post {
  String uid;
  String userName;
  String avatarUserPostUrl;
  String relationship;
  String content;
  String postId;
  List<dynamic> imagesUrls;
  String datePost;
  int likeCount;
  String address;
  String landlords;
  String price;

  Post({
    this.uid,
    this.avatarUserPostUrl,
    this.userName,
    this.content,
    this.postId,
    this.datePost,
    this.imagesUrls,
    this.likeCount,
    this.address,
    this.landlords,
    this.price,
  });

  Post.fromObject(dynamic o) {
    this.uid = o["uid"];
    this.avatarUserPostUrl = o["avatarUserPostUrl"];
    this.content = o["content"];
    this.datePost = o["datePost"];
    this.imagesUrls = o["imagesUrls"];
    this.likeCount = o["likeCount"];
    this.address = o["address"];
    this.landlords = o["landlords"];
    this.postId = o["postId"];
    this.price = o["price"];
    this.userName = o["userName"];
  }

  Map<String, dynamic> toJson() => {
        "uid": this.uid,
        "avatarUserPostUrl": this.avatarUserPostUrl,
        "content": this.content,
        "datePost": this.datePost,
        "imagesUrls": this.imagesUrls,
        "likeCount": this.likeCount,
        "address": this.address,
        "postId": this.postId,
        "landlords": this.landlords,
        "price": this.price,
        "userName": this.userName,
      };
}
