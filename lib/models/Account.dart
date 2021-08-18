class Account {
  int id;
  int userId;
  String number;
  String bank;
  String bankcode;
  String reservationreference;
  String accountreference;
  String createdAt;
  String updatedAt;

  Account(
      {this.id,
      this.userId,
      this.number,
      this.bank,
      this.bankcode,
      this.reservationreference,
      this.accountreference,
      this.createdAt,
      this.updatedAt});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    number = json['number'];
    bank = json['bank'];
    bankcode = json['bankcode'];
    reservationreference = json['reservationreference'];
    accountreference = json['accountreference'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['number'] = this.number;
    data['bank'] = this.bank;
    data['bankcode'] = this.bankcode;
    data['reservationreference'] = this.reservationreference;
    data['accountreference'] = this.accountreference;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
