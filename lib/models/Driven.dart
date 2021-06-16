class Driven {
  int id;
  int driverId;
  String amount;
  String destination;
  dynamic pickup1;
  dynamic pickup2;
  List<String> dropoffs;
  List<Pickups> pickups;
  String departureTime;
  int capacity;
  int status;
  String createdAt;
  String updatedAt;
  List<Passengers> passengers;

  Driven(
      {this.id,
      this.driverId,
      this.amount,
      this.destination,
      this.pickup1,
      this.pickup2,
      this.dropoffs,
      this.pickups,
      this.departureTime,
      this.capacity,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.passengers});

  Driven.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    amount = json['amount'];
    destination = json['destination'];
    pickup1 = json['pickup1'];
    pickup2 = json['pickup2'];
    dropoffs = json['dropoffs'].cast<String>();
    if (json['pickups'] != null) {
      pickups = new List<Pickups>();
      json['pickups'].forEach((v) {
        pickups.add(new Pickups.fromJson(v));
      });
    }
    departureTime = json['departure_time'];
    capacity = json['capacity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['passengers'] != null) {
      passengers = new List<Passengers>();
      json['passengers'].forEach((v) {
        passengers.add(new Passengers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['amount'] = this.amount;
    data['destination'] = this.destination;
    data['pickup1'] = this.pickup1;
    data['pickup2'] = this.pickup2;
    data['dropoffs'] = this.dropoffs;
    if (this.pickups != null) {
      data['pickups'] = this.pickups.map((v) => v.toJson()).toList();
    }
    data['departure_time'] = this.departureTime;
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.passengers != null) {
      data['passengers'] = this.passengers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pickups {
  String name;
  String place;

  Pickups({this.name, this.place});

  Pickups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    place = json['place'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['place'] = this.place;
    return data;
  }
}

class Passengers {
  int id;
  int rideId;
  int passengerId;
  int requestStatus;
  int seats;
  String pickup;
  int passengerRideStatus;
  String createdAt;
  String updatedAt;
  String fullName;
  String email;
  dynamic emailVerifiedAt;
  String password;
  String profileImage;
  String phoneNumber;
  String address;
  String workAddress;
  int userType;
  int status;
  int verified;
  String deviceToken;
  dynamic rememberToken;

  Passengers(
      {this.id,
      this.rideId,
      this.passengerId,
      this.requestStatus,
      this.seats,
      this.pickup,
      this.passengerRideStatus,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.email,
      this.emailVerifiedAt,
      this.password,
      this.profileImage,
      this.phoneNumber,
      this.address,
      this.workAddress,
      this.userType,
      this.status,
      this.verified,
      this.deviceToken,
      this.rememberToken});

  Passengers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideId = json['ride_id'];
    passengerId = json['passenger_id'];
    requestStatus = json['request_status'];
    seats = json['seats'];
    pickup = json['pickup'];
    passengerRideStatus = json['passenger_ride_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['full_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    profileImage = json['profile_image'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    workAddress = json['work_address'];
    userType = json['user_type'];
    status = json['status'];
    verified = json['verified'];
    deviceToken = json['device_token'];
    rememberToken = json['remember_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ride_id'] = this.rideId;
    data['passenger_id'] = this.passengerId;
    data['request_status'] = this.requestStatus;
    data['seats'] = this.seats;
    data['pickup'] = this.pickup;
    data['passenger_ride_status'] = this.passengerRideStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['profile_image'] = this.profileImage;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['work_address'] = this.workAddress;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['verified'] = this.verified;
    data['device_token'] = this.deviceToken;
    data['remember_token'] = this.rememberToken;
    return data;
  }
}
