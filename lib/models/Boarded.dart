class Boarded {
  int pid;
  int id;
  int rideId;
  int passengerId;
  int requestStatus;
  int seats;
  String pickup;
  int passengerRideStatus;
  String createdAt;
  String updatedAt;
  int driverId;
  String amount;
  String destination;
  dynamic pickup1;
  dynamic pickup2;
  List<String> knockoffs;
  List<Pickups> pickups;
  String departureTime;
  int capacity;
  int status;
  int car;
  Driver driver;
  int isRated;

  Boarded(
      {this.pid,
      this.id,
      this.rideId,
      this.passengerId,
      this.requestStatus,
      this.seats,
      this.pickup,
      this.passengerRideStatus,
      this.createdAt,
      this.updatedAt,
      this.driverId,
      this.amount,
      this.destination,
      this.pickup1,
      this.pickup2,
      this.knockoffs,
      this.pickups,
      this.departureTime,
      this.capacity,
      this.status,
      this.car,
      this.driver,
      this.isRated});

  Boarded.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    id = json['id'];
    rideId = json['ride_id'];
    passengerId = json['passenger_id'];
    requestStatus = json['request_status'];
    seats = json['seats'];
    pickup = json['pickup'];
    passengerRideStatus = json['passenger_ride_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driverId = json['driver_id'];
    amount = json['amount'];
    destination = json['destination'];
    pickup1 = json['pickup1'];
    pickup2 = json['pickup2'];
    knockoffs = json['knockoffs'].cast<String>();
    if (json['pickups'] != null) {
      pickups = new List<Pickups>();
      json['pickups'].forEach((v) {
        pickups.add(new Pickups.fromJson(v));
      });
    }
    departureTime = json['departure_time'];
    capacity = json['capacity'];
    status = json['status'];
    car = json['car'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    isRated = json['isRated'];
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
    data['passenger_ride_status'] = this.passengerRideStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['driver_id'] = this.driverId;
    data['amount'] = this.amount;
    data['destination'] = this.destination;
    data['pickup1'] = this.pickup1;
    data['pickup2'] = this.pickup2;
    data['knockoffs'] = this.knockoffs;
    if (this.pickups != null) {
      data['pickups'] = this.pickups.map((v) => v.toJson()).toList();
    }
    data['departure_time'] = this.departureTime;
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    data['car'] = this.car;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    data['isRated'] = this.isRated;
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

class Driver {
  int id;
  String fullName;
  String email;
  dynamic emailVerifiedAt;
  String profileImage;
  String phoneNumber;
  String address;
  String workAddress;
  int userType;
  int status;
  int verified;
  String deviceToken;
  dynamic rememberToken;
  String createdAt;
  String updatedAt;
  int driverId;
  String colour;
  String plateNumber;
  int capacity;
  String model;
  String modelYear;
  String brand;
  String license;
  String carPicture;
  dynamic rating;

  Driver(
      {this.id,
      this.fullName,
      this.email,
      this.emailVerifiedAt,
      this.profileImage,
      this.phoneNumber,
      this.address,
      this.workAddress,
      this.userType,
      this.status,
      this.verified,
      this.deviceToken,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.driverId,
      this.colour,
      this.plateNumber,
      this.capacity,
      this.model,
      this.modelYear,
      this.brand,
      this.license,
      this.carPicture,
      this.rating});

  Driver.fromJson(Map<String, dynamic> json) {
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
    driverId = json['driver_id'];
    colour = json['colour'];
    plateNumber = json['plate_number'];
    capacity = json['capacity'];
    model = json['model'];
    modelYear = json['model_year'];
    brand = json['brand'];
    license = json['license'];
    carPicture = json['car_picture'];
    rating = json['rating'];
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
    data['driver_id'] = this.driverId;
    data['colour'] = this.colour;
    data['plate_number'] = this.plateNumber;
    data['capacity'] = this.capacity;
    data['model'] = this.model;
    data['model_year'] = this.modelYear;
    data['brand'] = this.brand;
    data['license'] = this.license;
    data['car_picture'] = this.carPicture;
    data['rating'] = this.rating;
    return data;
  }
}
