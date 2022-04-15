import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';
import 'package:social_media_app/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String routeName = "/chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String _message = "";
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {


    final String postID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(postID)
                .collection("chat").orderBy("timeStamp")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.none){
                return const Center(child: Text("Error"));
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){

                              final QueryDocumentSnapshot doc =  snapshot.data!.docs[index];

                              final ChatModel chatModel = ChatModel(
                                  userId: doc['userID'] as String,
                                  message: doc['message'] as String,
                                  userName: doc['userName'] as String,
                                  timeStamp: doc['timeStamp'] as Timestamp,
                              );
                              
                            //  final ChatModel chatModel = ChatModel.fromSnapshot(doc);
                              
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: chatModel.userId == currentUserID ? Alignment.centerRight : Alignment.centerLeft,
                                  child: ChatBubble(chatModel, currentUserID),
                                ),
                              );
                            }),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(child: TextField(
                decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Message",
                ),
                            onChanged: (value){
                              _message = value.trim();
                },
                )),
                IconButton(
                onPressed: (){

                  if(_message.isNotEmpty){
                    FirebaseFirestore.instance.collection("posts").doc(postID).collection("chat").add(
                      {
                        "userID": FirebaseAuth.instance.currentUser!.uid,
                        "userName": FirebaseAuth.instance.currentUser!.displayName,
                        "message" : _message,
                        "timeStamp" : Timestamp.now(),

                      });

                    setState(() {
                      _message = "";
                    });
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios)
                ),
                ],
                      ),
                    )
                    ],
                ),
              );
            }

          ,

        ),
      ),
    );


   // return Container();
  }
}
