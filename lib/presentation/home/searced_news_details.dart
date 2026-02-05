import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as UI;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/news_details/social_media_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchedNewsDetails extends StatefulWidget {
  final String Newsid;

  const SearchedNewsDetails({Key? key, required this.Newsid}) : super(key: key);

  @override
  State<SearchedNewsDetails> createState() => _SearchedNewsDetailsState();
}

class _SearchedNewsDetailsState extends State<SearchedNewsDetails> {
  late final Controller provider;
  @override
  void initState() {
    super.initState();
    provider = context.read<Controller>();
    provider.getNewsById(widget.Newsid);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return Scaffold(
          appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              )),
          body: NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context),
        );
      }

      if (provider.searchedNews == null) {
        return Scaffold(
          appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              )),
          body: LoadingState(
                  stateRendererType: StateRendererType.fullScreenLoadingState)
              .getScreenWidget(context),
        );
      }

      if (provider.searchedNews!.newsId == "0") {
        return Scaffold(
          appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              )),
          body: ErrorState(
              stateRendererType: StateRendererType.fullScreenErorr,
              retryActionFunction: () {
                provider.searchedNews = null;
                provider.notifyListeners();
                provider.getNewsById(widget.Newsid);
              }).getScreenWidget(context),
        );
      }

      return Scaffold(
        appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            )),
        body: SafeArea(
          child: Directionality(
            textDirection:
                provider.EnTopicId.contains(provider.searchedNews!.newsTopicid)
                    ? UI.TextDirection.ltr
                    : UI.TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CachedNetworkImage(
                    height: size.height > size.width
                        ? size.height * AppSize.s_3
                        : size.width * AppSize.s_5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: provider.searchedNews!.newsPic!.trim(),
                    placeholder: (context, url) =>
                        SvgPicture.asset(ImageAssets.imagePhaceholder),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.searchedNews!.newsSubject!.trim(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: ColorManager.lightPrimary,
                              size: AppSize.s14,
                            ),
                            SizedBox(
                              width: AppSize.s4,
                            ),
                            Text(
                              provider.EnTopicId.contains(
                                      provider.searchedNews!.newsTopicid)
                                  ? provider.formatDate(
                                      provider.searchedNews!.newsDatetime!,
                                      AppStrings.englishLanguage)
                                  : provider.formatDate(
                                      provider.searchedNews!.newsDatetime!,
                                      AppStrings.arabicLanguage),
                              style: getMediumStyle(
                                  color: ColorManager.lightBlack),
                            ),
                          ],
                        ),
                        SocialMediaIcons(
                          newsId: provider.searchedNews!.newsId,
                          text: provider
                              .checkTranslatedNews(provider.searchedNews!),
                          transletedNewsId: provider.searchedNewsId(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p8,
                          ),
                          child: Html(
                            data: HtmlUnescape().convert(
                                provider.searchedNews!.newsBudy!.trim()),
                            onLinkTap: (url, attributes, element) =>
                                launchUrl(Uri.parse(url!),
                                    mode: LaunchMode.externalApplication),
                            style: {
                              'html': Style(
                                  color: ColorManager.black,
                                  fontSize: FontSize(FontSizeManager.s12),
                                  fontFamily: FontConstants.fontFamily,
                                  textAlign: TextAlign.justify),
                            },
                          ),
                        ),
                        Html(
                          data: provider.searchedNews!.newsAuth!.trim(),
                          onLinkTap: (url, attributes, element) =>
                              launchUrl(Uri.parse(url!),
                                  mode: LaunchMode.externalApplication),
                          style: {
                            'html': Style(
                                color: ColorManager.black,
                                fontSize: FontSize(FontSizeManager.s12),
                                fontFamily: FontConstants.fontFamily,
                                textAlign: TextAlign.justify),
                          },
                        ),
                        SizedBox(
                          height: AppSize.s12,
                        ),
                        Html(
                          data: provider.searchedNews!.newsRef!.trim(),
                          onLinkTap: (url, attributes, element) =>
                              launchUrl(Uri.parse(url!),
                                  mode: LaunchMode.externalApplication),
                          style: {
                            'html': Style(
                                color: ColorManager.black,
                                fontSize: FontSize(FontSizeManager.s12),
                                fontFamily: FontConstants.fontFamily,
                                textAlign: TextAlign.justify),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String convertToSecondCode(String firstCode) {
    String modifiedCode = firstCode.replaceAll(
      '<blockquote',
      '<div> <iframe  scrolling="no" frameborder="0"  allowfullscreen="true" sandbox = "" src=\'<blockquote ',
    );

    modifiedCode = modifiedCode.replaceAll('</blockquote>',
        '</blockquote>\'></iframe> </div> <iframe src="https://twitter.com/hus_yaghi/status/1686812603853705216" > </iframe>');

    log(modifiedCode);
    return modifiedCode;
  }

  String formatDate(String dateStr) {
    String currentLocale = Localizations.localeOf(context).languageCode;
    String weekday = DateFormat('E').format(DateTime.parse(dateStr));
    String day = dateStr.substring(8, 10);
    String month = dateStr.substring(5, 7);
    String year = dateStr.substring(0, 4);
    String hour = dateStr.substring(11, 13);
    String minute = dateStr.substring(14, 16);
    String meridiemAr = int.parse(hour) < 12 ? 'صباحًا' : 'مساءً';
    String meridiemEn = int.parse(hour) < 12 ? 'AM' : 'PM';

    String _getDayEn(String day) {
      final dayNames = {
        'الأحد': 'Sun',
        'الاثنين': 'Mon',
        'الثلاثاء': 'Tue',
        'الأربعاء': 'Wed',
        'الخميس': 'Thu',
        'الجمعة': 'Fri',
        'السبت': 'Sat',
      };
      print(weekday);
      return dayNames[day] ?? weekday;
    }

    String _getDayAr(String day) {
      final dayNames = {
        'Sun': 'الأحد',
        'Mon': 'الاثنين',
        'Tue': 'الثلاثاء',
        'Wed': 'الأربعاء',
        'Thu': 'الخميس',
        'Fri': 'الجمعة',
        'Sat': 'السبت',
      };
      return dayNames[day] ?? weekday;
    }

    String _getFormattedHour(String hourStr) {
      int hour = int.parse(hourStr);
      if (hour > 12) {
        hour -= 12;
      }
      return hour.toString().padLeft(2, '0');
    }

    if (currentLocale == AppStrings.arabicLanguage) {
      String time =
          "${_getDayAr(weekday)}، $day-$month-$year الساعة ${_getFormattedHour(hour.trim())}:${minute.trim()} $meridiemAr بتوقيت عدن";
      return time;
    } else {
      String time =
          "${_getDayEn(weekday)}, $day-$month-$year  ${_getFormattedHour(hour.trim())}:${minute.trim()} $meridiemEn, Aden";
      return time;
    }
  }
}
