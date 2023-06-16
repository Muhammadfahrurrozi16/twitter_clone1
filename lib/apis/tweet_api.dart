import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone1/models/tweet_model.dart';
import '../constants/constants.dart';
import '../core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tweetApiProvider = Provider((ref) {
  return TweetApi(
    db: ref.watch(appwriteDatabaseProvider));
});
abstract class ITweetApi{
  FutureEither<Document> shareTweet(Tweet tweet);
}

class TweetApi implements ITweetApi{
  final Databases _db;
  TweetApi({required Databases db }) :_db = db;
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
}