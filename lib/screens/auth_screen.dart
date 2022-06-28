import 'dart:ui';

import 'package:chatapp/widgets/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {

    void _submitAuthForm(String email, String password, String username,
        bool isLogin, BuildContext ctx) async {
      // AuthResult authResult;
      UserCredential authResult;
      print(password+"out");
      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          print(password+"in");
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          setState(() {
            _isLoading = false;
          });
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
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
            style: TextStyle(color: Colors.black),
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
            style: TextStyle(color: Colors.black),
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
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
