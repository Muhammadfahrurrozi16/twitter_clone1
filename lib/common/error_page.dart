import 'package:flutter/material.dart';

class Errortext extends StatelessWidget {
  final String error;
  const Errortext({
    super.key,
    required this.error,
    });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({
  super.key,
  required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Errortext(error: error),
    );
  }
}