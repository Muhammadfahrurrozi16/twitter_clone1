import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/common/common.dart';
import 'package:twitter_clone1/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone1/models/tweet_model.dart';
import '../widget/tweet_card.dart';
import '../../../constants/constants.dart';
class TweetList extends ConsumerWidget {
  const TweetList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetProvider).when(
      data: (tweet){
        return ref.watch(getlatesttweetProvider).when(
          data: (data){
            if (data.events.contains(
              'databases.*.collections.${AppwriteConstants.tweetCollection}.documents.*.create'
            )){tweet.insert(0, Tweet.fromMap(data.payload));
            }else if(data.events.contains(
              'databases.*.collections.${AppwriteConstants.tweetCollection}.documents.*.updata'
            )){
              final startingPoint = data.events[0].lastIndexOf('documents.');
              final endpoint = data.events[0].lastIndexOf('.update');
              final tweetId = data.events[0].substring(startingPoint +10,endpoint);
              var tweetz = tweet.where((element) => element.id == tweetId).first;
              final tweetIndex = tweet.indexOf(tweetz);
              tweet.removeWhere((element) => element.id == tweetId);

              tweetz = Tweet.fromMap(data.payload);
              tweet.insert(tweetIndex, tweetz);
            }

            return ListView.builder(
            itemCount: tweet.length,
            itemBuilder: (BuildContext context, index) {
            final tweets = tweet[index];
            return Tweetcard(tweets:tweets);
          },
          );
          }, error: (error, stackTrace) => Errortext(error: error.toString(),
        ), 
        loading: () {
          return ListView.builder(
            itemCount: tweet.length,
            itemBuilder: (BuildContext context, index) {
            final tweets = tweet[index];
            return Tweetcard(tweets:tweets);
          },
          );
        }
        );
        
      }, error: (error, stackTrace) => Errortext(error: error.toString()
      ), 
        loading: () => const Loader()
    );
  }
}