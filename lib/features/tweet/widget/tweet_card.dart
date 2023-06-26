// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/constants/assets_constants.dart';
import 'package:twitter_clone1/core/enum/tweet_type_enum.dart';
import 'package:twitter_clone1/features/tweet/view/reply_tweet.dart';
import '../controller/tweet_controller.dart';
import 'package:twitter_clone1/features/tweet/widget/carousol_image.dart';
import '../../../common/common.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone1/theme/pallete.dart';
import '../../../model/tweet_model.dart';
import 'package:timeago/timeago.dart'as time;
import '../../tweet/widget/hastag_write.dart';
import 'package:any_link_preview/any_link_preview.dart';
import '../widget/tweet_icon_button.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tweetcard extends ConsumerWidget {
  final Tweet tweets;
  const Tweetcard({super.key,required this.tweets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    return currentUser == null ? const SizedBox() : ref.watch(userDetailProvider(tweets.uid)).when(
      data: (user){
        return GestureDetector(
          onTap: () {
            Navigator.push(context, Replytweet.route(tweets));
          },
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tweets.retweetedBy.isNotEmpty)
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsConstants.retweetIcon,
                              color: Pallete.greyColor,
                              height: 20,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${tweets.retweetedBy} retweed',
                              style: const TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),  
                            )
                          ],
                        ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                              Text('@${user.name} . ${time.format(
                                tweets.tweetedAt,
                                locale: 'en_short')}',
                              style: const TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 17,
                              ),
                              ),
                            ],
                          ),
                          if (tweets.repliedTo.isNotEmpty)
                          ref.watch(getTweetByIDProvider(tweets.repliedTo)).when(
                            data: (repliedTotweet){
                              final replayTouser = ref.watch(userDetailProvider(repliedTotweet.uid,),).value;
                            return RichText(text: TextSpan(
                              text: 'Replying to',
                              style: const TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan( text: '@${replayTouser?.name}',
                                style: const TextStyle(
                                  color: Pallete.blueColor,
                                  fontSize: 16,
                                ),
                                ),
                              ],
                            ),
                            );
                            }, 
                            error: (error, stackTrace) => Errortext(
                              error: error.toString(),
                            ), 
                              
                              loading: () => const Loader(),
                          ),
                          Hastagtext(text: tweets.text),
                          if (tweets.tweetType == TweetType.images)
                          Carouselimage(imageLinks: tweets.imageLinks),
                          if(tweets.link.isNotEmpty) ...[
                            const SizedBox(height: 4,),
                            AnyLinkPreview(displayDirection: UIDirection.uiDirectionHorizontal,
                            link: 'https://${tweets.link}',
                            ),
                          ],
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TweeticonButton(
                                pathName: AssetsConstants.viewsIcon, 
                                text: (tweets.comentsIds.length + tweets.reshareCount + tweets.likes.length).toString(), 
                                onTap: (){}),
                             TweeticonButton(
                                pathName: AssetsConstants.retweetIcon, 
                                text: (tweets.reshareCount).toString(), 
                                onTap: (){
                                  ref.read(tweetControllerProvider.notifier).reShareTweet(tweets, currentUser, context);
                                }),
                              LikeButton(
                                size: 25,
                                onTap: (isLiked) async{
                                  ref.read(tweetControllerProvider.notifier).likeTweets(tweets, currentUser);
                                    return !isLiked;
                                },
                                isLiked: tweets.likes.contains(currentUser.uid),
                                likeBuilder: (isLiked) {
                                  return isLiked
                                  ? SvgPicture.asset(
                                    AssetsConstants.likeOutlinedIcon,
                                    color: Pallete.redColor,
                                  )
                                  :SvgPicture.asset(
                                    AssetsConstants.likeOutlinedIcon,
                                    color: Pallete.greyColor,
                                  );
                                },
                                likeCount: tweets.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Padding(padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked
                                      ? Pallete.redColor
                                      :Pallete.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  );
                                },
                              ),
                              IconButton(
                              onPressed: (){}, 
                              icon: const Icon(
                                Icons.share_outlined,
                                size: 25,
                                color: Pallete.greyColor,
                              ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 1,),
                        ],
                      ),
                  ), 
                ],
              ),
              const Divider(color: Pallete.greyColor,),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Errortext(
      error: error.toString()
      ), 
      loading: () => const Loader(),
    );
  }
  }