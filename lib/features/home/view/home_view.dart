// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/pallete.dart';
import '../../../constants/constants.dart';
import '../../tweet/view/create_tweet.dart';

class Homeview extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder:(context)=> const Homeview(),
  );
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  int _page = 0;
  final appBar = UIConstants.appBar();
  void onPageChange(int index){
    setState(() {
      _page =index;
    });
  }

  onCreateTweet(){
    Navigator.push(context, CreateTwetScreen.route());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
        ),
      bottomNavigationBar:CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items:[
          BottomNavigationBarItem(
          icon: SvgPicture.asset(
            _page == 0 
            ?AssetsConstants.homeFilledIcon
            :AssetsConstants.homeOutlinedIcon,
              color : Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
          icon: SvgPicture.asset(
            _page == 1 
            ?AssetsConstants.searchIcon
            :AssetsConstants.searchIcon,
              color : Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
          icon: SvgPicture.asset(
            _page == 2
            ?AssetsConstants.notifFilledIcon
            :AssetsConstants.notifOutlinedIcon,
              color : Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}