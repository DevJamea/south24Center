import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:south24/domain/modela/twitter_model.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

import '../resources/strings_mangaer.dart';

class TwitterItem extends StatelessWidget {
  const TwitterItem({Key? key, required this.twitterModel}) : super(key: key);

  final TwitterModel twitterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSize.s5,
      margin: EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p8),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTweetText(),
            SizedBox(height: AppSize.s12),
            _buildTweetInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTweetText() {
    return Text(
      twitterModel.twtTxt!.trim(),
      style: getSemiBoldStyle(color: ColorManager.black),
    );
  }

  Widget _buildTweetInfo(BuildContext context) {
    final TextStyle _infoTextStyle = TextStyle(fontSize: 12.0);
    return Row(
      children: [
        Icon(Icons.repeat, size: AppSize.s16),
        SizedBox(width: AppSize.s4),
        Text(twitterModel.twtRetweetCount.toString(), style: _infoTextStyle),
        SizedBox(width: AppSize.s16),
        Icon(Icons.favorite_border, size: AppSize.s16),
        SizedBox(width: AppSize.s4),
        Text(twitterModel.favoriteCount.toString(), style: _infoTextStyle),
        SizedBox(width: AppSize.s16),
        Text(
          "${AppStrings.posted.tr()} ${_calculateTime(twitterModel.twtTime!)} ${AppStrings.ago.tr()}",
          style: getSemiBoldStyle(color: ColorManager.primary),
        ),
      ],
    );
  }

  String _calculateTime(String timeInSeconds) {
    DateTime now = DateTime.now();
    DateTime tweetTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeInSeconds) * 1000);
    Duration difference = now.difference(tweetTime);
    if (difference.inMinutes < 1) {
      return AppStrings.lessThanMinute.tr();
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${AppStrings.minutes.tr()}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${AppStrings.hours.tr()}";
    } else {
      return "${difference.inDays} ${AppStrings.days.tr()}";
    }
  }

  
}
