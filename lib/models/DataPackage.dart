class DataPackage {
  String name;
  dynamic allowance;
  int price;
  dynamic validity;
  dynamic datacode;

  DataPackage(
      {this.name, this.allowance, this.price, this.validity, this.datacode});

  DataPackage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    allowance = json['allowance'];
    price = json['price'];
    validity = json['validity'];
    datacode = json['datacode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['allowance'] = this.allowance;
    data['price'] = this.price;
    data['validity'] = this.validity;
    data['datacode'] = this.datacode;
    return data;
  }
}
