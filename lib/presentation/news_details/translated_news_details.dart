import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
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

class TranslatedNewsDetailsView extends StatefulWidget {
  final String? newsId;

  const TranslatedNewsDetailsView({Key? key, required this.newsId})
      : super(key: key);

  @override
  State<TranslatedNewsDetailsView> createState() =>
      _TranslatedNewsDetailsViewState();
}

class _TranslatedNewsDetailsViewState extends State<TranslatedNewsDetailsView> {
  @override
  initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
    provider.getTranslartedNewsById(widget.newsId!);
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
          body: ErrorState(StateRendererType.fullScreenErrorState,
                  AppStrings.noInternetConnection.tr())
              .getScreenWidget(context),
        );
      }

      if (provider.translatedNews == null) {
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

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  height: size.height > size.width
                      ? size.height * AppSize.s_3
                      : size.width * AppSize.s_5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: provider.translatedNews!.newsPic!.trim(),
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
                        provider.translatedNews!.newsSubject!.trim(),
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
                            formatDate(provider.translatedNews!.newsDatetime!),
                            style:
                                getMediumStyle(color: ColorManager.lightBlack),
                          ),
                        ],
                      ),
                      SocialMediaIcons(
                          newsId: provider.translatedNews!.newsId,
                          text: null,
                          transletedNewsId: null),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppPadding.p8,
                        ),
                        child: Html(
                          data: provider.translatedNews!.newsBudy!.trim(),
                          onLinkTap: (url, context, attributes, element) =>
                              launchUrl(Uri.parse(url!),
                                  mode: LaunchMode.externalApplication),
                          style: {
                            'html': Style(
                                color: ColorManager.black,
                                fontSize: FontSize(FontSizeManager.s14),
                                fontFamily: FontConstants.fontFamily,
                                textAlign: TextAlign.justify),
                          },
                        ),
                      ),
                      Html(
                        data: provider.translatedNews!.newsAuth!.trim(),
                        onLinkTap: (url, context, attributes, element) =>
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
                        data: provider.translatedNews!.newsRef!.trim(),
                        onLinkTap: (url, context, attributes, element) =>
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
      );
    });
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
