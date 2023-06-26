import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/user_models.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
    builder:(context)=> UserProfileView(userModel:userModel)
  );
  final UserModel userModel;
  const UserProfileView({
  super.key, 
  required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold();
  }
}