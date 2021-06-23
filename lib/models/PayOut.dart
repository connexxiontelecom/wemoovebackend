class PayOut {
  int id;
  int userId;
  dynamic amount;
  int actionType;
  dynamic actionTakenBy;
  dynamic actionTakenDate;
  dynamic actionComment;
  String createdAt;
  String updatedAt;

  PayOut(
      {this.id,
      this.userId,
      this.amount,
      this.actionType,
      this.actionTakenBy,
      this.actionTakenDate,
      this.actionComment,
      this.createdAt,
      this.updatedAt});

  PayOut.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    actionType = json['action_type'];
    actionTakenBy = json['action_taken_by'];
    actionTakenDate = json['action_taken_date'];
    actionComment = json['action_comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['action_type'] = this.actionType;
    data['action_taken_by'] = this.actionTakenBy;
    data['action_taken_date'] = this.actionTakenDate;
    data['action_comment'] = this.actionComment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
