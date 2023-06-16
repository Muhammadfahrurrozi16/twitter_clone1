

import 'package:flutter/foundation.dart';

import 'package:twitter_clone1/core/enum/tweet_type_enum.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hastag;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> comentsIds;
  final String id;
  final int reshareCount;
  const Tweet({
    required this.text,
    required this.hastag,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.comentsIds,
    required this.id,
    required this.reshareCount,
  });

  Tweet copyWith({
    String? text,
    List<String>? hastag,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? comentsIds,
    String? id,
    int? reshareCount,
  }) {
    return Tweet(
      text: text ?? this.text,
      hastag: hastag ?? this.hastag,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      comentsIds: comentsIds ?? this.comentsIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'text': text});
    result.addAll({'hastag': hastag});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'tweetType': tweetType.type});
    result.addAll({'tweetedAt': tweetedAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'comentsIds': comentsIds});
    result.addAll({'reshareCount': reshareCount});
  
    return result;
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] ?? '', 
      hastag: List<String>.from(map['hastag']),
      link: map['link'] ?? '',
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['uid'] ?? '',
      tweetType: (map['tweetType' as String]).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']),
      likes: List<String>.from(map['likes']),
      comentsIds: List<String>.from(map['comentsIds']),
      id: map['\$id'] ?? '',
      reshareCount: map['reshareCount']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hastag: $hastag, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, comentsIds: $comentsIds, id: $id, reshareCount: $reshareCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tweet &&
      other.text == text &&
      listEquals(other.hastag, hastag) &&
      other.link == link &&
      listEquals(other.imageLinks, imageLinks) &&
      other.uid == uid &&
      other.tweetType == tweetType &&
      other.tweetedAt == tweetedAt &&
      listEquals(other.likes, likes) &&
      listEquals(other.comentsIds, comentsIds) &&
      other.id == id &&
      other.reshareCount == reshareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      hastag.hashCode ^
      link.hashCode ^
      imageLinks.hashCode ^
      uid.hashCode ^
      tweetType.hashCode ^
      tweetedAt.hashCode ^
      likes.hashCode ^
      comentsIds.hashCode ^
      id.hashCode ^
      reshareCount.hashCode;
  }
}
