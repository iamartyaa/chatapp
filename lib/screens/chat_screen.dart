import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(8.0),
          child: Text('This works!'),
        ),
        itemCount: 10,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        FirebaseFirestore.instance.collection('chats/LifgOTwV6eojbeX9rVJj/messages').snapshots().listen((event) { 
          // print(event.docs[0]['text']);
          event.docs.forEach((element) {
            print(element['text']);
          });
         });
      },child: Icon(Icons.add),),
    );
  }
}
