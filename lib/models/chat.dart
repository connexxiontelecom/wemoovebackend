class Chat {
  int id;
  int sender;
  int receiver;
  String replyto;
  dynamic replytoIndex;
  String message;
  int read;
  String time;
  String createdAt;
  String updatedAt;

  Chat(
      {this.id,
      this.sender,
      this.receiver,
      this.replyto,
      this.replytoIndex,
      this.message,
      this.read,
      this.time,
      this.createdAt,
      this.updatedAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    receiver = json['receiver'];
    replyto = json['replyto'];
    replytoIndex = json['replytoIndex'];
    message = json['message'];
    read = json['read'];
    time = json['time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['replyto'] = this.replyto;
    data['replytoIndex'] = this.replytoIndex;
    data['message'] = this.message;
    data['read'] = this.read;
    data['time'] = this.time;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
