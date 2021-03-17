class RegistrationErrors {
  List<String> name;
  List<String> email;
  List<String> password;
  List<String> phone;

  RegistrationErrors({this.name, this.email, this.password, this.phone});

  RegistrationErrors.fromJson(Map<String, dynamic> json) {
    name = json['name'].cast<String>();
    email = json['email'].cast<String>();
    password = json['password'].cast<String>();
    phone = json['phone'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    return data;
  }
}
