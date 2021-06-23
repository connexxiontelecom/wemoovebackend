class Bank {
  int id;
  String bank;
  Null createdAt;
  Null updatedAt;

  Bank({this.id, this.bank, this.createdAt, this.updatedAt});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bank = json['bank'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank'] = this.bank;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
