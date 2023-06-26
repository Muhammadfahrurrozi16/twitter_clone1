import 'package:flutter/material.dart';
import 'package:twitter_clone1/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({
    Key? key,
    required this.count,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSizes = 18;
    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: fontSizes,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: fontSizes,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
