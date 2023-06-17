import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/common/common.dart';
import 'package:twitter_clone1/features/tweet/controller/tweet_controller.dart';
import '../widget/tweet_card.dart';
class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetProvider).when(
      data: (tweet){
        return ListView.builder(
          itemCount: tweet.length,
          itemBuilder: (BuildContext context, index) {
            final tweets = tweet[index];
            return Tweetcard(tweets:tweets);
          },
          );
      }, error: (error, stackTrace) => Errortext(error: error.toString()
      ), 
        loading: () => const Loader()
        );
  }
}