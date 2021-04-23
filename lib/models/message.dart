class Message {
  final String sender;
  final String time;
  final String text;
  final bool unread;
  final bool isByMe;
  final dynamic senderid;
  final dynamic recipient;
  final String replyto;
  final dynamic replyindex;
  final String date;

  Message(
      {this.sender,
      this.time,
      this.text,
      this.unread,
      this.isByMe,
      this.senderid,
      this.recipient,
      this.replyto,
      this.replyindex,
      this.date});
}
