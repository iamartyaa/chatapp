import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserImagePicker extends StatefulWidget {
  
  final void Function(File) imagePickFn;
  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);
  
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final _picker = ImagePicker();
    final XFile? img = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    setState(() {
      _pickedImage = img;
    });
    widget.imagePickFn(File(_pickedImage!.path));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[450],
          backgroundImage: _pickedImage !=null ? FileImage(File(_pickedImage!.path)) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Profile Picture'),
        ),
      ],
    );
  }
}
