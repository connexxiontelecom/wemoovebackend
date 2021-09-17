class Addon {
  List<AvailablePricingOptions> availablePricingOptions;
  String code;
  String name;
  String description;

  Addon({this.availablePricingOptions, this.code, this.name, this.description});

  Addon.fromJson(Map<String, dynamic> json) {
    if (json['availablePricingOptions'] != null) {
      availablePricingOptions = new List<AvailablePricingOptions>();
      json['availablePricingOptions'].forEach((v) {
        availablePricingOptions.add(new AvailablePricingOptions.fromJson(v));
      });
    }
    code = json['code'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.availablePricingOptions != null) {
      data['availablePricingOptions'] =
          this.availablePricingOptions.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

class AvailablePricingOptions {
  int monthsPaidFor;
  int price;
  int invoicePeriod;

  AvailablePricingOptions({this.monthsPaidFor, this.price, this.invoicePeriod});

  AvailablePricingOptions.fromJson(Map<String, dynamic> json) {
    monthsPaidFor = json['monthsPaidFor'];
    price = json['price'];
    invoicePeriod = json['invoicePeriod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthsPaidFor'] = this.monthsPaidFor;
    data['price'] = this.price;
    data['invoicePeriod'] = this.invoicePeriod;
    return data;
  }
}
