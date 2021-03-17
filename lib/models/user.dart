class User {
  int id;
  String fullName;
  String email;
  Null emailVerifiedAt;
  String profileImage;
  String phoneNumber;
  Null address;
  int userType;
  int status;
  int verified;
  Null rememberToken;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
      this.fullName,
      this.email,
      this.emailVerifiedAt,
      this.profileImage,
      this.phoneNumber,
      this.address,
      this.userType,
      this.status,
      this.verified,
      this.rememberToken,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profile_image'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    userType = json['user_type'];
    status = json['status'];
    verified = json['verified'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_image'] = this.profileImage;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['verified'] = this.verified;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
