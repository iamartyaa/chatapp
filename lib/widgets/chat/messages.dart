import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, AsyncSnapshot<User?> futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data!.docs;
              // final user = ;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: ((context, index) => MessageBubble(
                      chatDocs[index]['username'],
                      chatDocs[index]['userimage'],
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == futureSnapshot.data!.uid,
                    )),
              );
            },
          );
        });
  }
}
