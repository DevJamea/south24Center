import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/domain/modela/infographics.dart';
import 'package:south24/domain/modela/news_model.dart';
import 'package:south24/domain/modela/twitter_model.dart';
import 'package:south24/domain/modela/youtube_model.dart';

class DataSource {
  DataSource._();
  static DataSource instance = DataSource._();

  Future<NewsJson> fetchNewsById(String url) async {
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final newsList = jsonData.map((data) => NewsJson.fromJson(data)).toList();
      if (newsList.isNotEmpty) {
        return newsList.first;
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<NewsJson>> fetchNewsData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final newsList = jsonData.map((data) => NewsJson.fromJson(data)).toList();
      return newsList;
    } else {
      throw Exception('Failed to load data');
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

  Future<List<ArabicVersions>> fetchArabicVersionsData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final versionsList =
          jsonData.map((data) => ArabicVersions.fromJson(data)).toList();
      return versionsList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Infographics>> fetchInfographicsData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final infographicsList =
          jsonData.map((data) => Infographics.fromJson(data)).toList();
      return infographicsList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<YoutubeModel>> fetchYoutubeData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final youtubeModelList =
          jsonData.map((data) => YoutubeModel.fromJson(data)).toList();
      return youtubeModelList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<TwitterModel>> fetchTwitterData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final encodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(encodedBody) as List<dynamic>;
      final twitterModelList =
          jsonData.map((data) => TwitterModel.fromJson(data)).toList();
      return twitterModelList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<File> loadPDF(url) async {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;
    var response = await http.get(Uri.parse(url));
    if (Platform.isAndroid) {
      File file = new File('/storage/emulated/0/Download/$fileName');
      await file.writeAsBytes(response.bodyBytes, flush: true);
      return file;
    } else {
      final downloadsDirectory = await getApplicationDocumentsDirectory();
      File file = new File('${downloadsDirectory.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes, flush: true);
      return file;
    }
  }
}
