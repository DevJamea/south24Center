import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SouthBottomAppBar extends StatelessWidget {
  const SouthBottomAppBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context , provider , child) {
        return BottomAppBar(
          elevation: AppSize.s8,
          child: SizedBox(
            height: AppSize.s28,
            width: size.width,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                  color: ColorManager.white,
                  child: Text(
                    AppStrings.breaking.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  width: AppSize.s2,
                  color: ColorManager.error,
                  height: double.infinity,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppPadding.p12),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        autoPlayCurve: Curves.easeInOutExpo,
                        autoPlay: true,
                        viewportFraction: 1),
                      items: provider.twitter.where((tweet) => tweet.hours! < 2).map((tweet) {
                        return Text(
                          tweet.twtTxt!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
