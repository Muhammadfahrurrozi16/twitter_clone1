import 'package:appwrite/appwrite.dart';
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
}
class UserApi implements IUserAPI {
  final Databases _db;
  UserApi ({required Databases db}) : _db= db;
  
  @override
  FutureEitherVoid saveUserData (UserModel userModel) async {
    try{
      await _db.createDocument(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.userCollection, documentId: ID.unique(), data: userModel.toMap(),);
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
}