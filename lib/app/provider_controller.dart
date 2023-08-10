import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:south24/app/app_prefs.dart';
import 'package:south24/app/constants.dart';
import 'package:south24/app/di.dart';
import 'package:south24/data/network/data_source.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/domain/modela/infographics.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/domain/modela/translated_news.dart';
import 'package:south24/domain/modela/twitter_model.dart';
import 'package:south24/domain/modela/youtube_model.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Controller extends ChangeNotifier {
  bool exceotionOccured = false;
  int current = 0;
  int currentReports = 0;
  int curretnTab = 0;
  int curretnReportsTab = 0;
  PageController pageController = PageController();
  PageController reporstPageController = PageController();
  TextEditingController searchController = TextEditingController();
  YoutubePlayerController? youtubePlayerController;
  String? selectedYoutube;
  String? pdfFilePath;

  TranslatedNews? newsDetails;
  TranslatedNews? searchedNews;
  TranslatedNews? translateNews;
  TranslatedNews? translatedNews;
  static GlobalKey<NavigatorState> navKey = GlobalKey();

  Controller() {
    getFcmToken();
  }

  Future<void> getFcmToken() async {
    // Get the FCM token
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('FCM Token: $fcmToken');
  }

  List<String> tabsAr = [
    AppStrings.home,
    AppStrings.analytics,
    AppStrings.reports,
    AppStrings.breakingNews,
    AppStrings.studiesAndResearch,
    AppStrings.publications,
    AppStrings.south24TV,
    AppStrings.about,
    AppStrings.language,
  ];

  List<String> tabsEn = [
    AppStrings.home,
    AppStrings.analytics,
    AppStrings.reports,
    AppStrings.breakingNews,
    AppStrings.publications,
    AppStrings.south24TV,
    AppStrings.south24Quarterly,
    AppStrings.about,
    AppStrings.language,
  ];

  List<String> EnTopicId = ["6", "15", "18", "20", "22", "25", "26"];

  List<NewsJson>? slider = [];
  List<NewsJson>? analytics = [];
  List<NewsJson>? editorial = [];
  List<NewsJson>? specialReports = [];
  List<NewsJson>? international = [];
  List<NewsJson>? historyAndCulture = [];
  List<NewsJson>? universityResearch = [];
  List<NewsJson>? arabic = [];
  List<NewsJson>? dialogues = [];
  List<NewsJson>? stdudies = [];
  List<NewsJson>? reports = [];
  List<NewsJson>? about = [];
  List<NewsJson>? searchList = [];

  List<ArabicVersions>? publications = [];
  List<ArabicVersions>? quarterly = [];
  List<ArabicVersions>? arabicVersions = [];

  List<Infographics>? infographic = [];
  List<YoutubeModel>? youtube = [];

  List<TwitterModel>? twitter = [];

  // return tabs list based language

  List<String> getTabsNames(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    if (currentLocale.languageCode == AppStrings.arabicLanguage) {
      return tabsAr;
    } else {
      return tabsEn;
    }
  }

// check internet

  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void startMonitoring() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      final bool hasInternet = await _checkInternetConnectivity();
      _isConnected = hasInternet;
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        _isConnected = false;
      } else {
        final bool hasInternet = await _checkInternetConnectivity();
        _isConnected = hasInternet;
      }
      notifyListeners();
    });
  }

  Future<bool> _checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // change Language

  final AppPreferences _appPreferences = instance<AppPreferences>();

  changeLanguage(BuildContext context) {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  changeLanguageToSpecific(BuildContext context, String language) {
    _appPreferences.changeAppLanguageToSpecific(language);
    Phoenix.rebirth(context);
  }

  // check list

  bool? checkTwittersNullable(BuildContext context) {
    if (twitter != null) {
      if (twitter!.where((tweet) => tweet.hours! < 2).isEmpty) {
        return true;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

// get data funcations

  Future<List<NewsJson>?> base(String url) async {
    return await DataSource.instance.fetchNewsData(url);
  }

  searchData(String query) async {
    String url = Constants.search + query;
    searchList = null;

    notifyListeners();
    searchList = await DataSource.instance.fetchSearchData(url);

    notifyListeners();
  }

  getNewsById(String id) async {
    searchedNews = null;
    String url = Constants.getNewsDetails + id;
    searchedNews = await DataSource.instance.fetchNewsById(url);
    notifyListeners();
  }

  getTranslartedNewsById(String id) async {
    translatedNews = null;
    String url = Constants.getNewsDetails + id;
    translatedNews = await DataSource.instance.fetchNewsById(url);
    notifyListeners();
  }

  getNewsDetails(String id) async {
    newsDetails = null;
    String url = Constants.getNewsDetails + id;
    newsDetails = await DataSource.instance.fetchNewsById(url);
    notifyListeners();
  }

  /// arabic

  getAnalyticsArNews() async {
    analytics = await base(Constants.analyticsAr);
    notifyListeners();
  }

  getSliderArNews() async {
    slider = await base(Constants.sliderAr);
    notifyListeners();
  }

  getEditorialNews() async {
    editorial = await base(Constants.editorial);
    notifyListeners();
  }

  getSpecialReportsNews() async {
    specialReports = await base(Constants.specialReports);
    notifyListeners();
  }

  getInternationalNews() async {
    international = await base(Constants.international);
    notifyListeners();
  }

  getHistoryAndCultureArNews() async {
    historyAndCulture = await base(Constants.historyAndCultureAr);
    notifyListeners();
  }

  getHistoryAndCultureEnNews() async {
    historyAndCulture = await base(Constants.historyAndCultureEn);
    notifyListeners();
  }

  getUniversityResearchArNews() async {
    universityResearch = await base(Constants.universityResearchAr);
    notifyListeners();
  }

  getUniversityResearchEnNews() async {
    universityResearch = await base(Constants.universityResearchEn);
    notifyListeners();
  }

  getArarbicNews() async {
    arabic = await base(Constants.arabic);
    notifyListeners();
  }

  getDialoguesNews() async {
    dialogues = await base(Constants.dialogues);
    notifyListeners();
  }

  getStdudiesNews() async {
    stdudies = await base(Constants.stdudies);
    notifyListeners();
  }

  getArabicVersionsNews() async {
    arabicVersions = await DataSource.instance
        .fetchArabicVersionsData(Constants.arabicVersions);
    notifyListeners();
  }

  getInfographicArNews() async {
    infographic = await DataSource.instance
        .fetchInfographicsData(Constants.infographicAr);
    notifyListeners();
  }

  /// engilsh

  getSliderEnNews() async {
    slider = await base(Constants.sliderEn);
    notifyListeners();
  }

  getAnalyticsEnNews() async {
    analytics = await base(Constants.analyticsEn);
    notifyListeners();
  }

  getReportsNews() async {
    reports = await base(Constants.reports);
    notifyListeners();
  }

  getPublicationsNews() async {
    publications = await DataSource.instance
        .fetchArabicVersionsData(Constants.publications);
    notifyListeners();
  }

  getInfographicEnNews() async {
    infographic = await DataSource.instance
        .fetchInfographicsData(Constants.infographicEn);
    notifyListeners();
  }

  getQuarterlyNews() async {
    quarterly =
        await DataSource.instance.fetchArabicVersionsData(Constants.quarterly);
    notifyListeners();
  }

  getTwitterArNews() async {
    twitter = await DataSource.instance.fetchTwitterData(Constants.twitterAr);
    notifyListeners();
  }

  getTwitterEnNews() async {
    twitter = await DataSource.instance.fetchTwitterData(Constants.twitterEn);
    notifyListeners();
  }

  Future<void> getYoutubeData() async {
    youtube = await DataSource.instance.fetchYoutubeData(Constants.southTv);

    if (youtube != null) {
      getYoutubeVideoPlayer(youtube![0].ytVideoId!);
    }
    notifyListeners();
  }

  void getYoutubeVideoPlayer(String videoId) {
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags:
            YoutubePlayerFlags(autoPlay: true, loop: true, hideControls: true));
    selectedYoutube = videoId;
    notifyListeners();
  }

  getMembers() async {
    about = await DataSource.instance.fetchAboutData(Constants.about);
    notifyListeners();
  }

  bool isArabic() {
    String languageCode =
        Localizations.localeOf(navKey.currentContext!).languageCode;
    if (languageCode == AppStrings.arabicLanguage) {
      return true;
    } else {
      return false;
    }
  }

  void animateToPage(int index) {
    curretnTab = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutSine);
    notifyListeners();
  }

  void animateToReportsPage(int index) {
    curretnReportsTab = index;
    if (reporstPageController.hasClients) {
      reporstPageController.animateToPage(index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutSine);
    }
    notifyListeners();
  }

  getNewsTranslate(String id) async {
    translateNews = null;
    String url = Constants.getNewsDetails + id;
    translateNews = await DataSource.instance.fetchNewsById(url);
    notifyListeners();
  }

  String? checkTranslatedNews(TranslatedNews translatedNews) {
    if (translatedNews.link_ar != null) {
      return "عربي";
    } else if (translatedNews.link_en != null) {
      return "English";
    } else {
      return null;
    }
  }

  String? TranslatedNewsId() {
    if (translateNews!.link_ar != null) {
      return translateNews!.link_ar;
    } else if (translateNews!.link_en != null) {
      return translateNews!.link_en;
    } else {
      return null;
    }
  }

  String? searchedNewsId() {
    if (searchedNews!.link_ar != null) {
      return searchedNews!.link_ar;
    } else if (searchedNews!.link_en != null) {
      return searchedNews!.link_en;
    } else {
      return null;
    }
  }

  showBottomSheet(Widget widget) {
    var height = MediaQuery.of(navKey.currentContext!).size.height;
    showModalBottomSheet(
      context: navKey.currentContext!,
      isScrollControlled: true,
      isDismissible: true,
      elevation: AppSize.s12,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSize.s12))),
      backgroundColor: ColorManager.white,
      useSafeArea: true,
      builder: (context) {
        return Container(
            height: height - AppSize.s120,
            child: Column(
              children: [
                Container(
                  width: AppSize.s100,
                  margin: EdgeInsets.symmetric(vertical: AppMargin.m8),
                  height: AppSize.s8,
                  decoration: BoxDecoration(
                      color: ColorManager.lightGrey,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(AppSize.s8),
                          left: Radius.circular(AppSize.s8))),
                ),
                Expanded(child: widget),
              ],
            ));
      },
    );
  }

  String formatDate(String dateStr, String language) {
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

    if (language == AppStrings.arabicLanguage) {
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
