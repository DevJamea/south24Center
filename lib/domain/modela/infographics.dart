class Infographics {
  String? infogId;
  String? infogImg;
  String? infogSbuject;
  String? infogTopicid;
  String? infogDatetime;
  String? infogDesigner;
  String? infogReads;

  Infographics(
      {this.infogId,
      this.infogImg,
      this.infogSbuject,
      this.infogTopicid,
      this.infogDatetime,
      this.infogDesigner,
      this.infogReads});

  Infographics.fromJson(Map<String, dynamic> json) {
    infogId = json['infog_id'];
     final baseUrl = 'https://south24.net/news/';
    final imagePath = json['infog_img'].replaceAll('../', '');
    final absoluteUrl = Uri.parse(baseUrl).resolve(imagePath).toString();
    infogImg = absoluteUrl;
    infogSbuject = json['infog_sbuject'];
    infogTopicid = json['infog_topicid'];
    infogDatetime = json['infog_datetime'];
    infogDesigner = json['infog_designer'];
    infogReads = json['infog_reads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['infog_id'] = this.infogId;
    data['infog_img'] = this.infogImg;
    data['infog_sbuject'] = this.infogSbuject;
    data['infog_topicid'] = this.infogTopicid;
    data['infog_datetime'] = this.infogDatetime;
    data['infog_designer'] = this.infogDesigner;
    data['infog_reads'] = this.infogReads;
    return data;
  }
}