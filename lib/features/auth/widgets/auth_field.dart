import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
            width: 3,
          ),
        ),
        contentPadding: const EdgeInsets.all(22.0),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}
