import 'dart:io';
import 'package:appwrite/appwrite.dart';
import '../constants/appwrite_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers.dart';

final storageApiProvider = Provider((ref) {
  return StorageApi(storage : ref.watch(appwriteStorageProvider));
});

class StorageApi{
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploudImage(List<File>files) async{
    List<String> imageLinks = [];
    for (final file in files){
    final uploudImage = await _storage.createFile(
    bucketId: AppwriteConstants.imageBucket, 
    fileId: ID.unique(), 
    file:InputFile.fromPath(path: file.path)
    );
    imageLinks.add(AppwriteConstants.imageUrl(uploudImage.$id)); 
    }
   return imageLinks;
  }
}
