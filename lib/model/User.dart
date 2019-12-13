class User {
  String avatarUrl;
  String coverUrl;
  String uid;
  String address;
  String phoneNumber;
  String fullName;
  String email;
  bool gender;
  String birthday;

  User({
    this.avatarUrl,
    this.phoneNumber,
    this.email,
    this.address,
    this.coverUrl,
    this.fullName,
    this.uid,
    this.birthday,
    this.gender = true,
  });

  User.fromObject(dynamic o) {
    this.fullName = o["fullName"];
    this.avatarUrl = o["avatarUrl"];
    this.uid = o["uid"];
    this.email = o["email"];
    this.address = o["address"];
    this.coverUrl = o["coverUrl"];
    this.phoneNumber = o["phoneNumber"];
    this.gender = o["gender"];
    this.birthday = o["birthday"];
  }

  Map<String, dynamic> toJson() => {
        'fullName': this.fullName,
        'avatarUrl': this.avatarUrl,
        'uid': this.uid,
        'email': this.email,
        'address': this.address,
        'coverUrl': this.coverUrl,
        'phoneNumber': this.phoneNumber,
        'gender': this.gender,
        'birthday': this.birthday,
      };
}
