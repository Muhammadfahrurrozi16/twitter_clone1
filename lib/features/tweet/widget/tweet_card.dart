import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/constants/assets_constants.dart';
import 'package:twitter_clone1/core/enum/tweet_type_enum.dart';
import 'package:twitter_clone1/features/tweet/widget/carousol_image.dart';
import '../../../common/common.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone1/theme/pallete.dart';
import '../../../models/tweet_model.dart';
import 'package:timeago/timeago.dart'as time;
import '../../tweet/widget/hastag_write.dart';
import 'package:any_link_preview/any_link_preview.dart';
import '../widget/tweet_icon_button.dart';

class Tweetcard extends ConsumerWidget {
  final Tweet tweets;
  const Tweetcard({super.key,required this.tweets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailProvider(tweets.uid)).when(
      data: (user){
        return Column(
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
                            )
                          ],
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
                              onTap: (){}),
                           TweeticonButton(
                              pathName: AssetsConstants.likeOutlinedIcon, 
                              text: (tweets.likes.length).toString(), 
                              onTap: (){}),
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
        );
      },
      error: (error, stackTrace) => Errortext(
      error: error.toString()
      ), 
      loading: () => const Loader(),
    );
  }
  }