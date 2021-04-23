class Request {
  int pid;
  int id;
  int rideId;
  int passengerId;
  int requestStatus;
  int seats;
  String pickup;
  String createdAt;
  String updatedAt;
  String fullName;
  String email;
  dynamic emailVerifiedAt;
  String password;
  String profileImage;
  String phoneNumber;
  dynamic address;
  int userType;
  int status;
  int verified;
  dynamic rememberToken;

  Request(
      {this.pid,
      this.id,
      this.rideId,
      this.passengerId,
      this.requestStatus,
      this.seats,
      this.pickup,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.email,
      this.emailVerifiedAt,
      this.password,
      this.profileImage,
      this.phoneNumber,
      this.address,
      this.userType,
      this.status,
      this.verified,
      this.rememberToken});

  Request.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    id = json['id'];
    rideId = json['ride_id'];
    passengerId = json['passenger_id'];
    requestStatus = json['request_status'];
    seats = json['seats'];
    pickup = json['pickup'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['full_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    profileImage = json['profile_image'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    userType = json['user_type'];
    status = json['status'];
    verified = json['verified'];
    rememberToken = json['remember_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['id'] = this.id;
    data['ride_id'] = this.rideId;
    data['passenger_id'] = this.passengerId;
    data['request_status'] = this.requestStatus;
    data['seats'] = this.seats;
    data['pickup'] = this.pickup;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['profile_image'] = this.profileImage;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['verified'] = this.verified;
    data['remember_token'] = this.rememberToken;
    return data;
  }
}
