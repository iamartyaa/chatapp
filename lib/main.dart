// ignore_for_file: deprecated_member_use

import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  // FirebaseFirestore.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home:StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,userSnapShot){
        if (userSnapShot.connectionState == ConnectionState.waiting){
          return const SplashScreen();
        }
        if (userSnapShot.hasData){
          return const ChatScreen();
        }
        return const AuthScreen();
      },),
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
      },
    );
  }
}
