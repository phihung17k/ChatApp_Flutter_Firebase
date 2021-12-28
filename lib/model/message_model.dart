class MessageModel {
  String? content;
  String? uidFrom;
  String? uidTo;
  int? timestamp;

  MessageModel({this.content, this.uidFrom, this.uidTo, this.timestamp});

  //convert Map<String, dynamic> to MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'],
      uidFrom: json['uidFrom'],
      uidTo: json['uidTo'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'uidFrom': uidFrom,
      'uidTo': uidTo,
      'timestamp': timestamp,
    };
  }
}
