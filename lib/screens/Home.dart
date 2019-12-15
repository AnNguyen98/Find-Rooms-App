import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:find_rooms_app/model/Post.dart';
import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/screens/Comments.dart';
import 'package:find_rooms_app/screens/Message.dart';
import 'package:find_rooms_app/screens/NewPost.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/Database.dart';
import 'package:find_rooms_app/widgets/GridImages.dart';
import 'package:find_rooms_app/widgets/NewPostButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static String title = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  DatabaseReference _postsRef;
  List<Post> posts = [];
  User user;
  Future<void> _onRefreshData() {
    _refreshIndicatorKey.currentState.show();
    return null;
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    _handleCheckNetwork();
    _getPosts();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        UIHelper.showSnackBarWithTitle(_globalKey, "No network!");
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        UIHelper.showSnackBarWithTitle(_globalKey, "You are online!");
      }
    });
    _currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Container(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefreshData,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return NewPostButton(
                  onPressedNewPost: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => NewPost(
                          user: user,
                        ),
                      ),
                    );
                  },
                  onPressedAvatar: () {},
                  avatar: user != null && user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl)
                      : AssetImage("images/avatar-default.png"),
                );
              } else {
                return posts.length == 0
                    ? Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text(
                            "Empty post!",
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                          ),
                        ),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 5, left: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      _handleToProfile(posts[index - 1].uid);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.yellow,
                                      backgroundImage: NetworkImage(
                                          posts[index - 1].avatarUserPostUrl),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _handleToProfile(posts[index - 1].uid);
                                      },
                                      child: Text(
                                        posts.length >= 1 &&
                                                posts[index - 1].userName !=
                                                    null
                                            ? posts[index - 1].userName
                                            : "A",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "1hr",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("ICON");
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.people,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: _handleMore,
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10, top: 5),
                                    child: Text(
                                      posts.length >= 1 &&
                                              posts[index - 1].content != null
                                          ? posts[index - 1].content
                                          : "",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  GridImages(
                                    imageUrls: posts[index - 1].imagesUrls,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.favorite),
                                  Text(posts[index - 1].likeCount.toString()),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      _handleLiked(
                                          posts[index - 1].postId, index - 1);
                                    },
                                    icon: Icon(FontAwesomeIcons.thumbsUp),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      _handleComments(posts[index - 1].postId);
                                    },
                                    icon: Icon(FontAwesomeIcons.comments),
                                  ),
                                  user.uid != posts[index - 1].uid
                                      ? IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            _handleMessage(
                                                posts[index - 1].uid);
                                          },
                                          icon: Icon(FontAwesomeIcons
                                              .facebookMessenger),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black38,
                            )
                          ],
                        ),
                      );
              }
            },
          ),
        ),
      ),
    );
  }

  _handleToProfile(String uid) {}

  _handleMessage(String uid) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Message(uid: uid),
      ),
    );
  }

  _handleComments(String postId) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Comments(
          postId: postId,
          user: this.user,
        ),
      ),
    );
  }

  _handleLiked(String postId, int index) {
    _postsRef = FirebaseDatabase.instance.reference().child("posts");
    _postsRef.child(postId.toString()).once().then((postData) {
      var post = Post.fromObject(postData.value);
      post.likeCount += 1;
      setState(() {
        posts[index] = post;
      });
      _postsRef.child(postId).set(post.toJson());
      print(post.likeCount);
    });
  }

  _handleMore() async {}

  _handleCheckNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      UIHelper.showSnackBarWithTitle(_globalKey, "No network!");
    }
  }

  _getPosts() async {
    _postsRef = FirebaseDatabase.instance.reference().child("postIds");
    _postsRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      List listPostIds = event.snapshot.value as List;
      print(listPostIds);
      posts = [];
      _postsRef = FirebaseDatabase.instance.reference().child("posts");
      listPostIds.forEach((postId) {
        _postsRef.child(postId.toString()).onValue.listen((postData) {
          setState(() {
            posts.add(Post.fromObject(postData.snapshot.value));
          });
          print(posts[0].avatarUserPostUrl);
        });
      });
    });
    posts.reversed;
  }

  _currentUser() async {
    await DatabaseHelper.getCurrentUser((userRes) {
      setState(() {
        user = userRes;
        print(user.fullName);
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }
}
