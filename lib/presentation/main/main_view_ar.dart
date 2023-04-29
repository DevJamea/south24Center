import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/footer/footer_view.dart';
import 'package:south24/presentation/main/grid_view_section.dart';
import 'package:south24/presentation/main/image_slider.dart';
import 'package:south24/presentation/main/list_view_section.dart';
import 'package:south24/presentation/main/news_widget.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:south24/presentation/widgets/news_widget_horizantal.dart';

class MianViewAr extends StatefulWidget {
  const MianViewAr({
    super.key,
  });

  @override
  State<MianViewAr> createState() => _MianStateAr();
}

class _MianStateAr extends State<MianViewAr> {
  @override
  void initState() {
    final provider = Provider.of<Controller>(context, listen: false);
    provider.analytics.isEmpty ? provider.getAnalyticsArNews() : null;
    provider.specialReports.isEmpty ? provider.getSpecialReportsNews() : null;
    provider.international.isEmpty ? provider.getInternationalNews() : null;
    provider.arabic.isEmpty ? provider.getArarbicNews() : null;
    provider.arabicVersions.isEmpty ? provider.getArabicVersionsNews() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      return !provider.isConnected
          ? ErrorState(StateRendererType.fullScreenErrorState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context)
          : provider.checkListsNullable(context)
              ? LoadingState(
                      stateRendererType:
                          StateRendererType.fullScreenLoadingState)
                  .getScreenWidget(context)
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageSlider(
                        size: size,
                        newsList: provider.analytics,
                      ),
                      const SizedBox(
                        height: AppSize.s14,
                      ),
                      ListViewSection(
                        size: size,
                        newsList: provider.analytics,
                        sectionName: AppStrings.analytics,
                        function: () {
                          provider.animateToPage(1);
                        },
                      ),
                      const SizedBox(
                        height: AppSize.s14,
                      ),
                      GridViewSection(
                        size: size,
                        newsList: provider.specialReports,
                        sectionName: AppStrings.specialReports,
                        function: () {
                          provider.animateToPage(2);
                          provider.animateToReportsPage(1);
                        },
                      ),
                      const SizedBox(
                        height: AppSize.s14,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.international.tr(),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            InkWell(
                              onTap: () {
                                provider.animateToPage(2);
                                provider.animateToReportsPage(2);
                              },
                              child: Text(
                                AppStrings.seeAll.tr(),
                                style:
                                    getSemiBoldStyle(color: ColorManager.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s4,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return NewsWidgetHorizantal(
                              size: size, news: provider.international[index]);
                        },
                      ),
                      const SizedBox(
                        height: AppSize.s14,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.arabic.tr(),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            InkWell(
                              onTap: () {
                                provider.animateToPage(2);
                                provider.animateToReportsPage(3);
                              },
                              child: Text(
                                AppStrings.seeAll.tr(),
                                style:
                                    getSemiBoldStyle(color: ColorManager.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s4,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppPadding.p12,
                                right: AppPadding.p12,
                                left: AppPadding.p12),
                            child: SizedBox(
                              width: double.infinity,
                              height: size.height * AppSize.s_3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppSize.s4),
                                child: NewsWidget(
                                  height: null,
                                  width: null,
                                  news: provider.arabic[index],
                                  textOverFlow: false,
                                  padding: AppPadding.p4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.latestRelease.tr(),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            InkWell(
                              onTap: () {
                                provider.animateToPage(5);
                              },
                              child: Text(
                                AppStrings.seeAll.tr(),
                                style:
                                    getSemiBoldStyle(color: ColorManager.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s4,
                      ),
                      SizedBox(
                        height: size.height * AppSize.s_3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.ArabicVersionsDetailsRoute,
                                  arguments: provider.arabicVersions[
                                      index], // Pass the news object as an argument
                                );
                              },
                              child: CachedNetworkImage(
                                height: size.height * AppSize.s_3,
                                width: size.width / AppSize.s2,
                                fit: BoxFit.cover,
                                imageUrl:
                                    provider.arabicVersions[index].docPic!,
                                placeholder: (context, url) => SvgPicture.asset(
                                    ImageAssets.imagePhaceholder),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: AppSize.s12,
                      ),
                      FooterView()
                    ],
                  ),
                );
    });
  }
}
