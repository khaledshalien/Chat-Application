import 'dart:io';
import 'package:chat_application/constants.dart';
import 'package:chat_application/messageBubble.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:chat_application/screens/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? message;
  var _firestore = FirebaseFirestore.instance;
  var _auth = FirebaseAuth.instance;
  User? loggedUser;
  var msgController = TextEditingController();
  var Picker = ImagePicker();
 late File _imageFile;


 PickerImage()async{
    var pickedFile = await Picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile!.path);
      uploadeImageTodb();
    });
  }
 uploadeImageTodb()async{
    String fileName = basename(_imageFile.path);
    Reference firebaseref = FirebaseStorage.instance.ref().child("images/${fileName}");
    UploadTask uploadTask = firebaseref.putFile(_imageFile);

    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl;


    _firestore.collection("messages").add({
      "sender": loggedUser!.email,
      'receiver' : UsersList.toUser,
      "text": url,
      'time': DateTime.now().millisecondsSinceEpoch,
      'type': '2',
    });
  }

  /*void getMessage()async{
  ////////////////not real time
    var messages = await  _firestore.collection("messages").get();
    for(var m in messages.docs){
      print(m.data());
    }
  }*/
  void messageStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }
  void getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      loggedUser = user;
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").orderBy('time',descending: true).snapshots(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.hasData) {
                    var messages = dataSnapshot.data!.docs;
                    List<MessageBubble> msgWidgets = [];
                    for (var msg in messages) {
                      Map map = msg.data() as Map;
                      var msgText = map['text'];
                      var msgSender = map['sender'];
                      var msgTime = map['time'];
                      var msgType = map['type'];
                      var msgWidget = MessageBubble(
                        text: msgText,
                        sender: msgSender,
                        isMe: loggedUser!.email== msgSender,
                        type : msgType,
                      );
                      msgWidgets.add(msgWidget);
                    }
                    return Expanded(
                        child: ListView(
                          reverse: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      children: msgWidgets,
                    ));
                  }
                  return Column();
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection("messages").add({
                        "sender": loggedUser!.email,
                        'receiver' : UsersList.toUser,
                        "text": message,
                        'time': DateTime.now().millisecondsSinceEpoch,
                        'type': '1',
                      });
                      msgController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  IconButton(
                      onPressed: PickerImage, icon: Icon(Icons.camera,color: Colors.lightBlueAccent,)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
