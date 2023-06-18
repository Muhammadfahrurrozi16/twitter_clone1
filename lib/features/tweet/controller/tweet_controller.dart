import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/apis/storage_api.dart';
import 'package:twitter_clone1/models/user_models.dart';
import '../../../apis/tweet_api.dart';
import 'package:twitter_clone1/core/enum/tweet_type_enum.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone1/models/tweet_model.dart';
import 'dart:io';
import '../../../core/core.dart';

final tweetControllerProvider = StateNotifierProvider<TweetControllers,bool>((ref) {
  return TweetControllers(
    ref: ref, 
    tweetApi: ref.watch(tweetApiProvider),
    storageApi: ref.watch(storageApiProvider),
    );
});

final getTweetProvider = FutureProvider((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweet();
});
final getRepliedProvider = FutureProvider.family((ref, Tweet tweet)  {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweet();
});
final getTweetByIDProvider = FutureProvider.family((ref, String id)  {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetbyID(id);
});

final getlatesttweetProvider = StreamProvider((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getLatestTweet();
});

class TweetControllers extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final Ref _ref;
  TweetControllers({
    required Ref ref,
    required TweetApi tweetApi,
    required StorageApi storageApi,
    }):_ref = ref,
    _tweetApi=tweetApi,
    _storageApi=storageApi,
     super(false);
  Future<List<Tweet>>getTweet() async{
    final tweetList = await _tweetApi.getTweet();
    return tweetList.map((tweet) =>Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet>getTweetbyID(String id) async{
    final tweets = await _tweetApi.getTweetbyID(id);
    return Tweet.fromMap(tweets.data);
  }
  Future<List<Tweet>>getRepliedTotweet(Tweet tweet) async{
    final documents = await _tweetApi.getTweet();
    return documents.map((tweet) =>Tweet.fromMap(tweet.data)).toList();
  }

  void likeTweets(Tweet tweet,UserModel user) async{
    List<String>likes = tweet.likes;

    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    }else{
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetApi.likeTweets(tweet);
    res.fold((l) => null, (r) => null);
  }
  void reShareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async{
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      comentsIds: [],
      reshareCount: tweet.reshareCount + 1,
      likes: [],
    );
    final res = await _tweetApi.updateReshareCount(tweet);
    res.fold((l) => showSnackbar(context,l.message),
     (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetApi.shareTweet(tweet);
      res2.fold(
        (l) => showSnackbar(context,l.message), 
        (r) => showSnackbar(context, 'retweet'));
     },
    );
  }
  void shareTweet({
    required List<File>images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }){
    if(text.isEmpty){
      showSnackbar(context, 'masukan kata');
      return;
    }
    if (images.isNotEmpty){
      _shareImageTweet(
        images: images, 
        text: text, 
        context: context,
        repliedTo : repliedTo,
        );
    }else {
      _shareTextTweet(
        text: text, 
        context: context,
        repliedTo : repliedTo,
        );
    }
  } 
  void _shareImageTweet({
    required List<File>images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  })async {
    state = true;
    final hastag = _getHastagFromtext(text);
    final link = _getLinkFromtext(text);
    final user = _ref.read(currentUserDetailProvider).value!;
    final imageLinks = await _storageApi.uploudImage(images);
    Tweet tweet = Tweet(
      text: text, 
      hastag: hastag, 
      link: link, 
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.images, 
      tweetedAt: DateTime.now(), 
      likes: const [], 
      comentsIds: const [],
      id: '', 
      reshareCount: 0,
      retweetedBy : '',
      repliedTo : repliedTo,
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackbar(context,l.message), (r) => null);
  }
  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  })async {
    state = true;
    final hastag = _getHastagFromtext(text);
    final link = _getLinkFromtext(text);
    final user = _ref.read(currentUserDetailProvider).value!;
    Tweet tweet = Tweet(
      text: text, 
      hastag: hastag, 
      link: link, 
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text, 
      tweetedAt: DateTime.now(), 
      likes: const [], 
      comentsIds: const [],
      id: '', 
      reshareCount: 0,
      retweetedBy : '',
      repliedTo : repliedTo,
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackbar(context,l.message), (r) => null);
  }
  String _getLinkFromtext(String text ){
    String link = '';
    List<String> wordInSentence = text.split('');
    for (String word in wordInSentence){
      if(word.startsWith('https://') || word.startsWith('www.')){
        link = word;
      }
    }
    return link;
  }
  List<String> _getHastagFromtext(String text ){
    List<String> hastag = [];
    List<String> wordInSentence = text.split('');
    for (String word in wordInSentence){
      if(word.startsWith('#')){
        hastag.add(word);
      }
    }
    return hastag;
  }
}