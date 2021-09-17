class databundleprovider {
  String serviceType;
  String shortname;
  int billerId;
  int productId;
  String name;

  databundleprovider(
      {this.serviceType,
      this.shortname,
      this.billerId,
      this.productId,
      this.name});

  databundleprovider.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    shortname = json['shortname'];
    billerId = json['biller_id'];
    productId = json['product_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_type'] = this.serviceType;
    data['shortname'] = this.shortname;
    data['biller_id'] = this.billerId;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    return data;
  }
}
