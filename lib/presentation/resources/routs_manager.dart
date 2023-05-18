import 'package:flutter/material.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/presentation/about/member_details.dart';
import 'package:south24/presentation/home/home_view.dart';
import 'package:south24/presentation/home/searced_news_details.dart';
import 'package:south24/presentation/home/search_screen.dart';
import 'package:south24/presentation/home/searched_member_details.dart';
import 'package:south24/presentation/news_details/news_details_view.dart';
import 'package:south24/presentation/publications/fullscreen_image.dart';
import 'package:south24/presentation/publications/show_publications_details.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String homeRoute = "/home";
  static const String detailsRoute = "/details";
  static const String ArabicVersionsDetailsRoute = "/arabicVersionsDetails";
  static const String FullscreenImageRoute = "/fullscreenImage";
  static const String MemberDetailsRoute = "/memberDetailsImage";
  static const String SearchScreenRoute = "/searchScreen";
  static const String SearchedNewsDetails = "/searchedNewsDetails";
  static const String SearchedMemberDetails = "/searchedMemberDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.detailsRoute:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => NewsDetailsView(news: args as NewsJson),
        );
      case Routes.ArabicVersionsDetailsRoute:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
              ShowPublicationsDetails(arabicVersions: args as ArabicVersions),
        );
      case Routes.FullscreenImageRoute:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => FullscreenImageView(imageUrl: args as String),
        );
      case Routes.MemberDetailsRoute:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => MemberDetails(newsJson: args as NewsJson),
        );
      case Routes.SearchedNewsDetails:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => SearchedNewsDetails(Newsid: args as String),
        );
        case Routes.SearchedMemberDetails:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => SearchedMemberDetails(memberId: args as String),
        );
      case Routes.SearchScreenRoute:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.noRouteFound),
            ),
            body: const Center(
              child: Text(AppStrings.noRouteFound),
            )));
  }
}
