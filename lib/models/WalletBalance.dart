class WalletHistory {
  int id;
  int userId;
  dynamic credit;
  dynamic debit;
  String narration;
  String createdAt;
  String updatedAt;

  WalletHistory(
      {this.id,
      this.userId,
      this.credit,
      this.debit,
      this.narration,
      this.createdAt,
      this.updatedAt});

  WalletHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    credit = json['credit'];
    debit = json['debit'];
    narration = json['narration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['credit'] = this.credit;
    data['debit'] = this.debit;
    data['narration'] = this.narration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
