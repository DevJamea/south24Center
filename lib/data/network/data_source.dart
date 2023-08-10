import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/domain/modela/infographics.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/domain/modela/translated_news.dart';
import 'package:south24/domain/modela/twitter_model.dart';
import 'package:south24/domain/modela/youtube_model.dart';

class DataSource {
  static final TranslatedNews errorTranlatedNews = TranslatedNews(
      newsId: "0",
      newsSubject: "",
      newsEsubject: "",
      newsBudy: "",
      newsEbudy: "",
      newsTopicid: "",
      newsPic: "",
      newsPictitle: "",
      newsAuth: "",
      newsRef: "",
      newsTags: "",
      newsDatetime: "",
      link_ar: "",
      link_en: "");
  DataSource._();
  static DataSource instance = DataSource._();

  Future<List<NewsJson>?> fetchNewsData(String url, {Function? onError}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final newsList = jsonData.map((data) => NewsJson.fromJson(data)).toList();
      if (newsList.isEmpty) {
        return null;
      } else {
        return newsList;
      }
    } else {
      onError?.call();
      return null;
    }
  }

  Future<List<NewsJson>?> fetchAboutData(String url, {Function? onError}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final newsList = jsonData.map((data) => NewsJson.fromJsonWithoutSubstring(data)).toList();
      if (newsList.isEmpty) {
        return null;
      } else {
        return newsList;
      }
    } else {
      onError?.call();
      return null;
    }
  }

  Future<List<YoutubeModel>?> fetchYoutubeData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final youtubeModelList =
          jsonData.map((data) => YoutubeModel.fromJson(data)).toList();
      if (youtubeModelList.isEmpty) {
        return null;
      } else {
        return youtubeModelList;
      }
    } else {
      return null;
    }
  }

  Future<List<ArabicVersions>?> fetchArabicVersionsData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final versionsList =
          jsonData.map((data) => ArabicVersions.fromJson(data)).toList();
      if (versionsList.isEmpty) {
        return null;
      } else {
        return versionsList;
      }
    } else {
      return null;
    }
  }

  Future<List<Infographics>?> fetchInfographicsData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final infographicsList =
          jsonData.map((data) => Infographics.fromJson(data)).toList();
      if (infographicsList.isEmpty) {
        return null;
      } else {
        return infographicsList;
      }
    } else {
      return null;
    }
  }

  Future<TranslatedNews?> fetchNewsById(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final newsList =
          jsonData.map((data) => TranslatedNews.fromJson(data)).toList();
      if (newsList.isNotEmpty) {
        return newsList.first;
      } else {
        return errorTranlatedNews;
      }
    } else {
      return errorTranlatedNews;
    }
  }

  Future<List<NewsJson>> fetchSearchData(String url) async {
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final document = parser.parse(encodedBody);
      final preTags = document.getElementsByTagName('pre');
      final jsonData = json.decode(preTags.first.text) as List<dynamic>;
      final newsList = jsonData.map((data) => NewsJson.fromJson(data)).toList();
      return newsList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TwitterModel>?> fetchTwitterData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final twitterModelList =
          jsonData.map((data) => TwitterModel.fromJson(data)).toList();
      if (twitterModelList.isEmpty) {
        return null;
      } else {
        return twitterModelList;
      }
    } else {
      return null;
    }
  }
}
