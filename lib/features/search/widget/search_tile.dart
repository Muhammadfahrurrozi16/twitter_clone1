import 'package:flutter/material.dart';
import 'package:twitter_clone1/theme/theme.dart';
import '../../../model/user_models.dart';
import '../../profile_user/views/user_profile.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(context, UserProfileView.route(userModel),)
        ;
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePic),
        radius: 30,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        children: [
          Text(
          '@${userModel.name}',
           style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        ),
          Text(
          userModel.bio,
           style: const TextStyle(
          color: Pallete.whiteColor,
        ),
        ),
        ],
      ),
    );
  }
}