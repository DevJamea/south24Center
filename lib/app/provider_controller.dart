import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:south24/app/app_prefs.dart';
import 'package:south24/app/constants.dart';
import 'package:south24/app/di.dart';
import 'package:south24/data/network/data_source.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/domain/modela/infographics.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/domain/modela/twitter_model.dart';
import 'package:south24/domain/modela/youtube_model.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Controller extends ChangeNotifier {
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
  NewsJson? searchedNews;
  static GlobalKey<NavigatorState> navKey = GlobalKey();

  Controller() {}

  List<String> tabsAr = [
    AppStrings.home,
    AppStrings.analytics,
    AppStrings.reports,
    AppStrings.breakingNews,
    AppStrings.studies,
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

  List<NewsJson> analytics= [];
  List<NewsJson> editorial = [];
  List<NewsJson> specialReports = [];
  List<NewsJson> international = [];
  List<NewsJson> arabic = [];
  List<NewsJson> dialogues = [];
  List<NewsJson> stdudies = [];
  List<ArabicVersions> arabicVersions = [];
  List<Infographics> infographic = [];
  List<YoutubeModel> youtube = [];
  List<TwitterModel> twitter = [];
  List<NewsJson> about = [];
  List<NewsJson>? searchList = [];

  List<NewsJson> reports = [];
  List<ArabicVersions> publications = [];
  List<ArabicVersions> quarterly = [];


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

  // check list

  bool checkListsNullable(BuildContext context) {
    if (isArabic()) {
      if (specialReports.isEmpty ||
          analytics.isEmpty ||
          international.isEmpty ||
          arabic.isEmpty ||
          arabicVersions.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      if (reports.isEmpty || analytics.isEmpty || publications.isEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }


  bool checkPublicationsNullable(BuildContext context) {
    if (isArabic()) {
      if (arabicVersions.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      if (publications.isEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool checkTwittersNullable(BuildContext context) {
    if (twitter.where((tweet) => tweet.hours! < 2).isEmpty) {
        return true;
      } else {
        return false;
      }
  }

// get data funcations

  Future<List<NewsJson>> base(String url) async {
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

  getSliderImageAr() {
    getAnalyticsArNews();
    notifyListeners();
  }

  /// arabic

  getAnalyticsArNews() async {
    analytics = await base(Constants.analyticsAr);
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

    getYoutubeVideoPlayer(youtube[0].ytVideoId!);
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

  downloadPdfFile(String url) async {
    await DataSource.instance.loadPDF(url);
  }

  getMembers() async {
    about = await base(Constants.about);
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
    reporstPageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutSine);
    notifyListeners();
  }
}
