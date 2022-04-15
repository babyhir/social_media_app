import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel{

  final String userId;

  final String userName;

  final String message;

  final Timestamp timeStamp;

  ChatModel({
    required this.userId,
    required this.message,
    required this.userName,
    required this.timeStamp,

  });


  // ChatModel.fromSnapshot(QueryDocumentSnapshot doc)
  //     : userId = doc["userId"] as String,
  //       userName = doc["userName"] as String,
  //       timeStamp = doc["timeStamp"] as Timestamp,
  //       message = doc["message"] as String;

       // message = doc["message"] as String,
       // timeStamp = doc["timeStamp"] as Timestamp;

}