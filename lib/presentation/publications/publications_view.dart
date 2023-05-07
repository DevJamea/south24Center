import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/publications/infographics.dart';
import 'package:south24/presentation/publications/sub_publications.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class PublicationsView extends StatefulWidget {
const PublicationsView({Key? key}) : super(key: key);

@override
State<PublicationsView> createState() => _PublicationsViewState();
}

class _PublicationsViewState extends State<PublicationsView> {
final PageController _pageController = PageController();
final List<String> _tabs = [
AppStrings.subPublications.tr(),
AppStrings.infographics.tr(),
];
int _currentTab = 0;

@override
Widget build(BuildContext context) {
final Size screenSize = MediaQuery.of(context).size;

return Consumer<Controller>(
  builder: (context, provider, child) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: screenSize.width,
              color: ColorManager.lightPrimary,
              child: TabBar(
                onTap: (value) {
                  setState(() {
                    _currentTab = value;
                  });
                  _pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutSine,
                  );
                },
                isScrollable: true,
                indicatorColor: ColorManager.secondery,
                labelColor: ColorManager.white,
                indicatorWeight: AppSize.s4,
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p8,
                ),
                labelStyle: TextStyle(
                  fontSize: FontSizeManager.s10,
                  color: ColorManager.white,
                  fontFamily: FontConstants.fontFamily,
                  fontWeight: FontWeightManager.semiBold,
                ),
                tabs: _tabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tabs.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SubPublicationsView();
                  } else {
                    return const InfographicsView();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  },
);
}
}