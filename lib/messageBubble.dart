import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final  text;
  final sender;
  final isMe;
  final type;


  MessageBubble({
    required this.type,
    required this.text,
    required this.sender,
    required this.isMe,

  });

  @override
  Widget build(BuildContext context) {
    if(type == "1") {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment
              .start,
          children: [
            Text("$sender",
              style: TextStyle(fontSize: 12, color: Colors.black54),),
            Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 5,
              color: isMe ? Colors.lightBlue : Colors.white,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("$text", style: TextStyle(fontSize: 16,
                      color: isMe ? Colors.white : Colors.black),)),
            ),
          ],
        ),
      );
    }
    else
      return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment
            .start,
        children: [
          Text("$sender",
            style: TextStyle(fontSize: 12, color: Colors.black54),),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                image: NetworkImage("$text"),


              ),
            ),
          ),
        ],
      ),
    );
  }
}
