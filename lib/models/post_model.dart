import 'package:cloud_firestore/cloud_firestore.dart';

class Post{

  final String userId;

  final String userName;

  final Timestamp timeStamp;

  final String imageUrl;

  final String description;

  final String postID;

  Post({
    required this.userId,
    required this.userName,
    required this.timeStamp,
    required this.imageUrl,
    required this.description,
    required this.postID,

  });

  Post.fromSnapshot(QueryDocumentSnapshot doc)
      : timeStamp = doc["timeStamp"] as Timestamp,
        description = doc["description"] as String,
        imageUrl = doc["imageUrl"] as String,
        userId = doc["userId"] as String,
        userName = doc["userName"] as String,
        postID = doc["postID"] as String;

}