enum TweetType{
  text('text'),
  images('images');

  final String type;
  const TweetType(this.type);
}

  extension ConvertTweet on String {
    TweetType toTweetTypeEnum(){
      switch (this){
        case 'text':
          return TweetType.text;
        case 'image':
          return TweetType.images;
        default:
          return TweetType.text;
      }
    }
}