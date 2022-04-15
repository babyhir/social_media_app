
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/widgets/post_item.dart';
import 'dart:io';

import 'chat_screen.dart';
//import 'package:social_media_app/models/post_model.dart';

class PostsScreen extends StatefulWidget {

  static const String routeName = "/posts_screen";


  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

//Future<List<Post>>? posts;

/*
  @override
  void initState() {

    posts = FirebaseFirestore.instance.collection("posts").get().then((
        QuerySnapshot querySnapshot){
      List<Post> posts = [];

      for(QueryDocumentSnapshot doc in querySnapshot.docs){
        posts.add(Post(
          userName: doc["userName"] as String,
          timeStamp: doc["timeStamp"] as Timestamp,
          description: doc["description"] as String,
          userId: doc["userId"] as String,
          imageUrl: doc["imageUrl"] as String,
        ));
      }

      return posts;

    });

    super.initState();
  }
  */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {

            // TODO 1. Get Image
            final ImagePicker imagePicker = ImagePicker();

            final XFile? xFile = await imagePicker.pickImage(
                source: ImageSource.gallery, imageQuality: 50);

            if (xFile != null) {

              Navigator.of(context).pushNamed(
                  CreatePostScreen.routeName,
                  arguments: File(xFile.path),
              );

            }


            // TODO 2. Go to Create Post if image != null

            // TODO 1. Get Image





          }, icon: const Icon(Icons.add, size: 30)),
          IconButton(onPressed: (){

            FirebaseAuth.instance.signOut();

            // FirebaseAuth.instance.signOut().then((value) =>
            //     Navigator.of(context).pushReplacementNamed(
            //         SignInScreen.routeName),
            //);

          }, icon: const Icon(Icons.logout, size: 30)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts").orderBy("timeStamp")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError || snapshot.connectionState == ConnectionState.none){
            return const Center(child:  Text("Oops. Something went wrong."));
          }

          if (snapshot.connectionState == ConnectionState.waiting){
              // || snapshot.connectionState == ConnectionState.active
          //){
              return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(

// todo change item count
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){

                final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

                // final Post post = Post(
                //   timeStamp: doc["timeStamp"] as Timestamp,
                //   description: doc["description"] as String ,
                //   imageUrl: doc["imageUrl"] as String,
                //   userId: doc["userId"] as String,
                //   userName: doc["userName"] as String,
                //   postID: doc["postID"] as String,
                // );
                final Post post = Post.fromSnapshot(doc);


                return PostItem(post);
                // return GestureDetector(
                //   onTap: (){
                //
                //     Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: post.postID);
                //
                //
                //         //FirebaseFirestore.instance.collection("posts").doc(post.postID)
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         Container(
                //           height: MediaQuery.of(context).size.width,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             image: DecorationImage(
                //               image: NetworkImage(post.imageUrl),
                //               fit: BoxFit.cover,
                //             )
                //           ) ,
                //         ),
                //         //Image.network(post.imageUrl),
                //         const SizedBox(height: 6),
                //         Text(post.userName, style:Theme.of(context).textTheme.headline6),
                //         const SizedBox(height: 6),
                //         Text(post.description, style: Theme.of(context).textTheme.headline5),
                //       ],
                //     ),
                //   ),
                // );
              }
          );
        },
      )
    );
  }
}


