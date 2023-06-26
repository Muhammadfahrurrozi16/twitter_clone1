import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone1/features/tweet/widget/tweet_card.dart';
import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../model/tweet_model.dart';
import '../../../constants/constants.dart';
class Replytweet extends ConsumerWidget {
  static route(Tweet tweets) => MaterialPageRoute(
    builder:(context)=> Replytweet(
      tweets: tweets,
    ),
  );
  final Tweet tweets;
  const Replytweet({
    super.key,
    required this.tweets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Tweet'),
      ),
      body: Column(
        children: [
          Tweetcard(tweets: tweets),
      ref.watch(getRepliedProvider(tweets)).when(
      data: (tweet){
        return ref.watch(getlatesttweetProvider).when(
          data: (data){
            final latestTweet = Tweet.fromMap(data.payload);

            bool isTweetAlready = false;
            for(final tweetModel in tweet){
              if (tweetModel.id == latestTweet.id
              ) {
                isTweetAlready= true;
                break;
              }
            }
            if (!isTweetAlready && latestTweet.repliedTo == tweets.id){

            
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
          }

            return Expanded(
              child: ListView.builder(
              itemCount: tweet.length,
              itemBuilder: (BuildContext context, index) {
              final tweets = tweet[index];
              return Tweetcard(tweets:tweets);
                      },
                      ),
            );
          }, error: (error, stackTrace) => Errortext(error: error.toString(),
        ), 
        loading: () {
          return Expanded(
            child: ListView.builder(
              itemCount: tweet.length,
              itemBuilder: (BuildContext context, index) {
              final tweets = tweet[index];
              return Tweetcard(tweets:tweets);
            },
            ),
          );
        }
        );
        
      }, error: (error, stackTrace) => Errortext(error: error.toString()
      ), 
        loading: () => const Loader()
    ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            images: [], 
            text: value, 
            context: context,
            repliedTo : tweets.id,
            );
        },
        decoration:  const InputDecoration(
          hintText: 'balas tweet',
        ),
      ),
    );
  }
}