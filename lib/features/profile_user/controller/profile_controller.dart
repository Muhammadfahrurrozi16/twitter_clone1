import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/tweet_model.dart';
import '../../../apis/tweet_api.dart';

final userProfilControllerProvider = StateNotifierProvider((ref) {
  return UserProfilControllers(tweetApi: ref.watch(tweetApiProvider),);

});

final getUserTweetProvider = FutureProvider.family((ref,String uid) async {
  final searchController = ref.watch(userProfilControllerProvider.notifier);
  return searchController.gettweetUser(uid);
});

class UserProfilControllers extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  UserProfilControllers({
    required TweetApi tweetApi,
  }): _tweetApi = tweetApi, 
  super(false);

  Future<List<Tweet>>gettweetUser(String uid) async{
    final tweet = await _tweetApi.gettweetUser(uid);
    return tweet.map((e) => Tweet.fromMap(e.data)).toList();
  }
  
}