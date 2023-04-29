class ArabicVersions {
  String? docId;
  String? docSubject;
  String? docPic;
  String? docPdf;
  String? docDatetime;
  String? docTopicid;
  String? docReads;
  String? docAuth;
  String? docPrice;
  String? docIssue;
  String? docAddress;

  ArabicVersions(
      {this.docId,
      this.docSubject,
      this.docPic,
      this.docPdf,
      this.docDatetime,
      this.docTopicid,
      this.docReads,
      this.docAuth,
      this.docPrice,
      this.docIssue,
      this.docAddress});

  ArabicVersions.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    docSubject = json['doc_subject'];
    final baseUrl = 'https://south24.net/news/';
    final imagePath = json['doc_pic'].replaceAll('../', '');
    final absoluteUrl = Uri.parse(baseUrl).resolve(imagePath).toString();
    docPic = absoluteUrl;
    final pdfPath = json['doc_pdf'].replaceAll('../', '');
    final absolutePdfUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();
    docPdf = absolutePdfUrl;
    docDatetime = json['doc_datetime'];
    docTopicid = json['doc_topicid'];
    docReads = json['doc_reads'];
    docAuth = json['doc_auth'];
    docPrice = json['doc_price'];
    docIssue = json['doc_issue'];
    docAddress = json['doc_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['doc_subject'] = this.docSubject;
    data['doc_pic'] = this.docPic;
    data['doc_pdf'] = this.docPdf;
    data['doc_datetime'] = this.docDatetime;
    data['doc_topicid'] = this.docTopicid;
    data['doc_reads'] = this.docReads;
    data['doc_auth'] = this.docAuth;
    data['doc_price'] = this.docPrice;
    data['doc_issue'] = this.docIssue;
    data['doc_address'] = this.docAddress;
    return data;
  }
}