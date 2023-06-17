import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/common.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone1/theme/pallete.dart';
import '../../../models/tweet_model.dart';
import 'package:timeago/timeago.dart'as time;
import '../../tweet/widget/hastag_write.dart';

class Tweetcard extends ConsumerWidget {
  final Tweet tweets;
  const Tweetcard({super.key,required this.tweets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailProvider(tweets.uid)).when(
      data: (user){
        return Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                    radius: 35,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Text('@${user.name} . ${time.format(
                              tweets.tweetedAt,
                              locale: 'en_short')}',
                            style: const TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 17,
                            ),
                            )
                          ],
                        ),
                        Hastagtext(text: tweets.text),
                      ],
                    ),
                ), 
              ],
            )
          ],
        );
      },
      error: (error, stackTrace) => Errortext(
      error: error.toString()
      ), 
      loading: () => const Loader(),
    );
  }
  }