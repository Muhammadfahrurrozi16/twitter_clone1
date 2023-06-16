class AppwriteConstants {
  static const String databaseId = '6417c84c68fef24206a9';
  static const String projectId = '6417bc496f0ee924b61f';
  static const String endPoint = 'https://baas.pasarjepara.com/v1';
  static const String userCollection = '647d3e5ae713932d55e2';
  static const String tweetCollection = '648a3f48ced9c19aa53c';
  static const String imageBucket = '648bc4078aa8382995be';
  static String imageUrl(String imageId) =>
  '$endPoint/storage/buckets/$imageBucket/files/$imageId/download?project=$projectId&mode=admin';
}