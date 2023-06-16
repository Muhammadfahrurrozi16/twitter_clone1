import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/constants/assets_constants.dart';
import 'package:twitter_clone1/core/core.dart';
import 'package:twitter_clone1/features/auth/controller/auth_controller.dart';
import '../../../common/common.dart';
import '../../../theme/pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/tweet_controller.dart';
class CreateTwetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder:(context)=> const CreateTwetScreen(),
  );
  const CreateTwetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTwetScreenState();
}

class _CreateTwetScreenState extends ConsumerState<CreateTwetScreen> {
  final tweetTextControllers = TextEditingController();
  List<File>images = [];
  @override
  void dispose(){
    super.dispose();
    tweetTextControllers.dispose();
  }

  void  shareTweet(){
    ref.read(tweetControllerProvider.notifier).shareTweet(
      images: images, 
      text: tweetTextControllers.text,
      context: context,
      );
    }
  void onpickImages() async{
    images = await pickImage();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close,size: 30,),
        ),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet, 
            label: 'tweet',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body:isLoading || currentUser == null
      ?const Loader()
      : SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(currentUser.profilePic),
                  radius: 30,
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: TextField(
                    controller: tweetTextControllers,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'apa yang terjadi',
                      hintStyle: TextStyle(
                        color: Pallete.greyColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                      border: InputBorder.none
                    ),
                    maxLines: null,
                  ),
                  ),
              ],
            ),
            if (images.isNotEmpty)
              CarouselSlider(items: images.map((file) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Image.file(file));
              },
              ).toList(),
              options: CarouselOptions(
                height: 400,
                enableInfiniteScroll: false,
              ),
            ),
          ],
        )
       ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
      child : Row(
        children: [
          Padding(padding: const EdgeInsets.all(8.0).copyWith(
            left: 15,
            right: 15,
          ),
          child: GestureDetector(
            onTap: onpickImages,
            child: SvgPicture.asset(AssetsConstants.galleryIcon)),
          ),
          Padding(padding: const EdgeInsets.all(8.0).copyWith(
            left: 15,
            right: 15,
          ),
          child: SvgPicture.asset(AssetsConstants.gifIcon),
          ),
          Padding(padding: const EdgeInsets.all(8.0).copyWith(
            left: 15,
            right: 15,
          ),
          child: SvgPicture.asset(AssetsConstants.emojiIcon),
          ),
        ],
      )
      )
    );
  }
}