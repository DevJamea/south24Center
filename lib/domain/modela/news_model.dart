import 'package:html/parser.dart' as html;

class NewsJson {
  String? newsId;
  String? newsSubject;
  String? newsEsubject;
  String? newsBudy;
  String? newsEbudy;
  String? newsTopicid;
  String? newsPic;
  String? newsPictitle;
  String? newsAuth;
  String? newsRef;
  String? newsTags;
  String? newsDatetime;

  NewsJson(
      {required this.newsId,
      required this.newsSubject,
      required this.newsEsubject,
      required this.newsBudy,
      required this.newsEbudy,
      required this.newsTopicid,
      required this.newsPic,
      required this.newsPictitle,
      required this.newsAuth,
      required this.newsRef,
      required this.newsTags,
      required this.newsDatetime});

  NewsJson.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'] ?? "";
    newsSubject = json['news_subject'] ?? "";
    newsEsubject = json['news_esubject'] ?? "";
    try {
      newsBudy = html
          .parse(json['news_budy'] ?? "")
          .documentElement!
          .text
          .substring(0, 200);
    } catch (e) {
      newsBudy = json['news_budy'] ?? "";
    }
    newsEbudy = json['news_ebudy'] ?? "";
    newsTopicid = json['news_topicid'] ?? "";
    // Convert relative image URL to absolute URL
    final baseUrl = 'https://south24.net/news/';
    final imagePath = json['news_pic'].replaceAll('../', '');
    final absoluteUrl = Uri.parse(baseUrl).resolve(imagePath).toString();
    newsPic = absoluteUrl;
    newsPictitle = json['news_pictitle'] ?? "";
    newsAuth = json['news_auth'] ?? "";
    newsRef = json['news_ref'] ?? "";
    newsTags = json['news_tags'] ?? "";
    newsDatetime = json['news_datetime'] ?? "";
  }

  NewsJson.fromJsonWithoutSubstring(Map<String, dynamic> json) {
    newsId = json['news_id'] ?? "";
    newsSubject = json['news_subject'] ?? "";
    newsEsubject = json['news_esubject'] ?? "";
    newsBudy = json['news_budy'] ?? "";
    newsEbudy = json['news_ebudy'] ?? "";
    newsTopicid = json['news_topicid'] ?? "";
    // Convert relative image URL to absolute URL
    final baseUrl = 'https://south24.net/news/';
    final imagePath = json['news_pic'].replaceAll('../', '');
    final absoluteUrl = Uri.parse(baseUrl).resolve(imagePath).toString();
    newsPic = absoluteUrl;
    newsPictitle = json['news_pictitle'] ?? "";
    newsAuth = json['news_auth'] ?? "";
    newsRef = json['news_ref'] ?? "";
    newsTags = json['news_tags'] ?? "";
    newsDatetime = json['news_datetime'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_id'] = this.newsId;
    data['news_subject'] = this.newsSubject;
    data['news_esubject'] = this.newsEsubject;
    data['news_budy'] = this.newsBudy;
    data['news_ebudy'] = this.newsEbudy;
    data['news_topicid'] = this.newsTopicid;
    data['news_pic'] = this.newsPic;
    data['news_pictitle'] = this.newsPictitle;
    data['news_auth'] = this.newsAuth;
    data['news_ref'] = this.newsRef;
    data['news_tags'] = this.newsTags;
    data['news_datetime'] = this.newsDatetime;
    return data;
  }
}
