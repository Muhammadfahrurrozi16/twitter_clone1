import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme.dart';
import 'constants.dart';
import '../features/tweet/widget/tweet_list.dart';
import '../features/search/views/search_view.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
      ),
      centerTitle: true,
    );
  }
  static const List<Widget>bottomTabBarPages = [
    TweetList(),
    SearchView(),
    Text('notifikasi screen')
  ];
}
