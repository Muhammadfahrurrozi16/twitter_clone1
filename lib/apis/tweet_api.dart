import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone1/models/tweet_model.dart';
import '../constants/constants.dart';
import '../core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tweetApiProvider = Provider((ref) {
  return TweetApi(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );

});
abstract class ITweetApi{
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweet();
  Future<Document> getTweetbyID(String id);
  Future<List<Document>> getRepliedTotweet(Tweet tweet);
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweets(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
}

class TweetApi implements ITweetApi{
  final Databases _db;
  final Realtime _realtime;
  TweetApi({required Databases db,
   required Realtime realtime
   }) :_db = db,
   _realtime=realtime;
  @override 
  FutureEither<Document>shareTweet(Tweet tweet)async{
    try{
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId, 
        collectionId: AppwriteConstants.tweetCollection, 
        documentId: ID.unique(), 
        data: tweet.toMap(),
        );
    return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    } 
  }
  @override 
  FutureEither<Document>likeTweets(Tweet tweet)async{
    try{
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId, 
        collectionId: AppwriteConstants.tweetCollection, 
        documentId: tweet.id, 
        data:{
          'likes' : tweet.likes
        }
        );
    return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    } 
  }
  @override
  Future<List<Document>> getTweet() async{
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection,
      queries: [Query.orderDesc('tweetedAt'),
      ]
      );
    return documents.documents;
  }
  @override
  Stream<RealtimeMessage> getLatestTweet(){
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetCollection}.documents'
    ]).stream;
  }
  
  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try{
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId, 
        collectionId: AppwriteConstants.tweetCollection, 
        documentId: tweet.id, 
        data:{
          'reshareCount' : tweet.reshareCount
        }
        );
    return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    } 
  }
  
  @override
  Future<List<Document>> getRepliedTotweet(Tweet tweet)async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.tweetCollection,
      queries: [
        Query.equal('repliedTo', tweet.id)
      ]);
      return document.documents;
  }
  
  @override
  Future<Document> getTweetbyID(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetCollection,
      documentId: id,);
  }
}