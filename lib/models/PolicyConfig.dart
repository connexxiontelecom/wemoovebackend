class PolicyConfig {
  int id;
  int minimumThreshold;
  double chargeRate;
  int setBy;
  String createdAt;
  String updatedAt;

  PolicyConfig(
      {this.id,
      this.minimumThreshold,
      this.chargeRate,
      this.setBy,
      this.createdAt,
      this.updatedAt});

  PolicyConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minimumThreshold = json['minimum_threshold'];
    chargeRate = json['charge_rate'];
    setBy = json['set_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minimum_threshold'] = this.minimumThreshold;
    data['charge_rate'] = this.chargeRate;
    data['set_by'] = this.setBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
