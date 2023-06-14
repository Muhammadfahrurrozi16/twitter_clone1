import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../constants/constants.dart';
import '../core/core.dart';
import '../models/user_models.dart';

final userApiProvider = Provider((ref){
  return UserApi(db: ref.watch(appwriteDatabaseProvider));
});
abstract class IUserAPI{
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<models.Document> getUserData(String uid);
}
class UserApi implements IUserAPI {
  final Databases _db;
  UserApi ({required Databases db}) : _db= db;
  
  @override
  FutureEitherVoid saveUserData (UserModel userModel) async {
    try{
      await _db.createDocument(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.userCollection, documentId: userModel.uid, data: userModel.toMap(),);
    return right(null);
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
  Future<models.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId:AppwriteConstants.databaseId, 
      collectionId: AppwriteConstants.userCollection,
      documentId: uid);
  }
}