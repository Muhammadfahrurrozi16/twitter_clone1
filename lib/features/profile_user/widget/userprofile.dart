import 'package:twitter_clone1/common/common.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import '../../tweet/widget/tweet_card.dart';
import '../../../model/user_models.dart';
import '../../../theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/follow_count.dart';
import '../../profile_user/controller/profile_controller.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key,
  required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    return currentUser == null ?
    const Loader()
    :NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled){
        return [
          SliverAppBar(
            expandedHeight: 158,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(child: user.bannerPic.isEmpty?Container(
                  color:  Pallete.blueColor,
                )
                : Image.network(user.bannerPic),
                ),
                Positioned(
                  bottom:  0,
                  child: CircleAvatar(backgroundImage: NetworkImage(user.profilePic),
                  radius: 45,
                  ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Pallete.whiteColor,
                          width: 1.5,
                        )
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    ),
                     child: Text(
                      currentUser.uid == user.uid
                      ? 'edit Profile'
                      :'follow',
                      style: const TextStyle(
                        color: Pallete.whiteColor,
                      ),
                     ),
                     ),
                  )
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Text(user.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
              Text(
                '@${user.name}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Pallete.greyColor,
                ),
              ),
              Text(
                user.bio,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  FollowCount(count: user.followers.length -1,
                   text: 'followers',),
                   FollowCount(count: user.following.length -1,
                  text: 'following,'),
                ],
              ),
              const SizedBox(height: 2),
              const Divider(
                color: Pallete.whiteColor,
              ),
            ])),)
        ];
      },
      body: ref.watch(getUserTweetProvider(user.uid)).when(
              data: (tweet) {
                    return ListView.builder(
                      itemCount: tweet.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweets = tweet[index];
                        return Tweetcard(tweets: tweets);
                      },
                    );
      }, error: (error, stackTrace) => Errortext(error: error.toString()
      ), 
        loading: () => const Loader()
    ),
    );
  }
}