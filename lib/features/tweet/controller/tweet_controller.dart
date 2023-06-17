import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/apis/storage_api.dart';
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

  void shareTweet({
    required List<File>images,
    required String text,
    required BuildContext context,
  }){
    if(text.isEmpty){
      showSnackbar(context, 'masukan kata');
      return;
    }
    if (images.isNotEmpty){
      _shareImageTweet(
        images: images, 
        text: text, 
        context: context);
    }else {
      _shareTextTweet(
        text: text, 
        context: context);
    }
  } 
  void _shareImageTweet({
    required List<File>images,
    required String text,
    required BuildContext context,
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
      reshareCount: 0
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackbar(context,l.message), (r) => null);
  }
  void _shareTextTweet({
    required String text,
    required BuildContext context,
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
      reshareCount: 0
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