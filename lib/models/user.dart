class User {
  int id;
  String fullName;
  String email;
  dynamic emailVerifiedAt;
  String profileImage;
  String phoneNumber;
  dynamic address;
  dynamic workAddress;
  int userType;
  int status;
  int verified;
  String deviceToken;
  dynamic rememberToken;
  String createdAt;
  String updatedAt;
  int currentRideStatus;
  int currentRequestStatus;
  int hasvehicle;

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
      this.deviceToken,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.currentRideStatus,
      this.currentRequestStatus,
      this.hasvehicle});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profile_image'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    workAddress = json['work_address'];
    userType = json['user_type'];
    status = json['status'];
    verified = json['verified'];
    deviceToken = json['device_token'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    currentRideStatus = json['current_ride_status'];
    currentRequestStatus = json['current_request_status'];
    hasvehicle = json['hasvehicle'];
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
    data['work_address'] = this.workAddress;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['verified'] = this.verified;
    data['device_token'] = this.deviceToken;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['current_ride_status'] = this.currentRideStatus;
    data['current_request_status'] = this.currentRequestStatus;
    data['hasvehicle'] = this.hasvehicle;
    return data;
  }
}
