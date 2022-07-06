// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:chatapp/widgets/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    void submitAuthForm(String email, String password, String username,
        File? image, bool isLogin, BuildContext ctx) async {
      // AuthResult authResult;
      UserCredential authResult;
      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          setState(() {
            _isLoading = false;
          });
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${authResult.user!.uid}.jpg');
          await ref.putFile(image!).whenComplete(() {
            
          });

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'imageUrl': url,
          });
          setState(() {
            _isLoading = false;
          });
        }
      } on PlatformException catch (err) {
        var message = 'An error occured, please check your credentials';

        if (err.message != null) {
          message = err.message!;
        }

        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
            err.toString(),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm, _isLoading),
    );
  }
}
