class Bank {
  int id;
  String bank;
  String createdAt;
  String updatedAt;

  Bank({this.id, this.bank, this.createdAt, this.updatedAt});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bank = json['bank_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_name'] = this.bank;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
