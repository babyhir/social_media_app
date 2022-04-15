import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;


class CreatePostScreen extends StatefulWidget {

  static const String routeName = "/create_post_screen";

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {


  final _formKey = GlobalKey<FormState>();
  String _description = "";

  Future<void> _submit(File image) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    // Write image to Storage

    storage.FirebaseStorage firebaseStorage = storage.FirebaseStorage.instance;
    late String imageUrl;
    await firebaseStorage.ref("image/${UniqueKey().toString()}.png").putFile(image).then((taskSnapshot) async {
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    });
    // Add to Cloud Firestore

    final CollectionReference collectionReference = FirebaseFirestore.instance.collection("posts");
    collectionReference.add(
      {
        "userId" : FirebaseAuth.instance.currentUser!.uid,
        "description" : _description,
        "timeStamp" : Timestamp.now(),
        "userName" : FirebaseAuth.instance.currentUser!.displayName,
        "imageUrl" : imageUrl,
        "postID" : ""
      }).then((docReference) => docReference.update({"postID" : docReference.id})
            );
      //  });


    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final File image = ModalRoute.of(context)!.settings.arguments as File;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Image.file(image, fit: BoxFit.cover),
            //Description Text Field
            TextFormField(
              onSaved: (value) {
                _description = value!;
              },
              validator:  (value){

                if (value == null || value.isEmpty){
                  return "Please provide description";
                }

                return null;

              },
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                )
              ),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(image),



            )
          ],
        ),
      ),
    );
  }
}
