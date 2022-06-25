import 'package:flutter/material.dart';

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
        
      },child: Icon(Icons.add),),
    );
  }
}
