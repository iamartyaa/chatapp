import 'dart:isolate';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  var userEmail = '';
  var userName = '';
  var userPassword = '';
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    // FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      // print(userPassword);
      widget.submitFn(userEmail, userPassword, userName, _isLogIn, context);
    }

    //once validated we can send to firebase
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                  ),
                  FlatButton.icon(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                    icon: Icon(Icons.image),
                    label: Text('Add Profile Picture'),
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userEmail = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!_isLogIn)
                    TextFormField(
                      key: ValueKey('name'),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be atleast 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: () {
                        _trySubmit();
                      },
                      child: Text(_isLogIn ? 'LogIn' : 'SignUp'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogIn = !_isLogIn;
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                          _isLogIn ? 'Create new Account' : 'Login instead'),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
