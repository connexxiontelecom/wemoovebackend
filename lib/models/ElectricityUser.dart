class ElectricityUser {
  String name;
  String address;
  String outstandingBalance;
  Null dueDate;
  String district;
  String accountNumber;
  Null minimumAmount;
  Null rawOutput;
  Null errorMessage;

  ElectricityUser(
      {this.name,
      this.address,
      this.outstandingBalance,
      this.dueDate,
      this.district,
      this.accountNumber,
      this.minimumAmount,
      this.rawOutput,
      this.errorMessage});

  ElectricityUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    outstandingBalance = json['outstandingBalance'];
    dueDate = json['dueDate'];
    district = json['district'];
    accountNumber = json['accountNumber'];
    minimumAmount = json['minimumAmount'];
    rawOutput = json['rawOutput'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['outstandingBalance'] = this.outstandingBalance;
    data['dueDate'] = this.dueDate;
    data['district'] = this.district;
    data['accountNumber'] = this.accountNumber;
    data['minimumAmount'] = this.minimumAmount;
    data['rawOutput'] = this.rawOutput;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
