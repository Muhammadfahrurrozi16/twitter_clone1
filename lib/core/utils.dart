import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
String getNamefromEmail(String email){
  return email.split('@')[0];
}
Future<List<File>>pickImage()async{
  List<File>images = [];
  final ImagePicker picker =ImagePicker();
  final imagefiles =await picker.pickMultiImage();
  if (imagefiles.isNotEmpty){
    for (final image in imagefiles){
      images.add(File(image.path));
    }
  }
  return images;
}
