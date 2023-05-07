class YoutubeModel {
  String? ytId;
  String? ytVideoId;
  String? ytTitle;
  String? ytTitlee;
  String? ytDes;
  String? ytUrl;
  String? ytDatetime;
  String? published;

  YoutubeModel(
      {this.ytId,
      this.ytVideoId,
      this.ytTitle,
      this.ytTitlee,
      this.ytDes,
      this.ytUrl,
      this.ytDatetime,
      this.published});

  YoutubeModel.fromJson(Map<String, dynamic> json) {
    ytId = json['yt_id'] ?? "";
    ytVideoId = json['yt_videoId'] ?? "";
    ytTitle = json['yt_title'] ?? "";
    ytTitlee = json['yt_titlee'] ?? "";
    ytDes = json['yt_des'] ?? "";
    ytUrl = json['yt_url'] ?? "";
    ytDatetime = json['yt_datetime'] ?? "";
    published = json['published'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yt_id'] = this.ytId;
    data['yt_videoId'] = this.ytVideoId;
    data['yt_title'] = this.ytTitle;
    data['yt_titlee'] = this.ytTitlee;
    data['yt_des'] = this.ytDes;
    data['yt_url'] = this.ytUrl;
    data['yt_datetime'] = this.ytDatetime;
    data['published'] = this.published;
    return data;
  }
}