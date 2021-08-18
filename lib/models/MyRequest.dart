import 'Car.dart';

class MyRequest {
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
  String fare;
  String dropoff;
  String destination;
  String pickup1;
  String pickup2;
  List<String> dropoffs;
  List<Pickups> pickups;
  String departureTime;
  int capacity;
  int status;
  int negotiated;
  int paymentMode;
  int passengers;
  Driver driver;
  Car car;

  MyRequest(
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
      this.fare,
      this.dropoff,
      this.destination,
      this.pickup1,
      this.pickup2,
      this.dropoffs,
      this.pickups,
      this.departureTime,
      this.capacity,
      this.status,
      this.negotiated,
      this.paymentMode,
      this.passengers,
      this.driver,
      this.car});

  MyRequest.fromJson(Map<String, dynamic> json) {
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
    fare = json['fare'];
    dropoff = json['dropoff'];
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
    negotiated = json['negotiated'];
    paymentMode = json['payment_mode'];
    passengers = json['passengers'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    car = json['Car'] != null ? new Car.fromJson(json['Car']) : null;
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
    data['dropoffs'] = this.dropoffs;
    if (this.pickups != null) {
      data['pickups'] = this.pickups.map((v) => v.toJson()).toList();
    }
    data['departure_time'] = this.departureTime;
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    data['passengers'] = this.passengers;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    return data;
  }
}

class Pickups {
  String name;
  String place;
  String traveltime;

  Pickups({this.name, this.place, this.traveltime});

  Pickups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    place = json['place'];
    traveltime = json["traveltime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['place'] = this.place;
    data["traveltime"] = this.traveltime;
    return data;
  }
}

class Driver {
  int id;
  String fullName;
  String email;
  Null emailVerifiedAt;
  String profileImage;
  String phoneNumber;
  dynamic address;
  int userType;
  int status;
  int verified;
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

  Driver(
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
      this.updatedAt,
      this.driverId,
      this.colour,
      this.plateNumber,
      this.capacity,
      this.model,
      this.modelYear,
      this.brand,
      this.license});

  Driver.fromJson(Map<String, dynamic> json) {
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
    driverId = json['driver_id'];
    colour = json['colour'];
    plateNumber = json['plate_number'];
    capacity = json['capacity'];
    model = json['model'];
    modelYear = json['model_year'];
    brand = json['brand'];
    license = json['license'];
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
    data['driver_id'] = this.driverId;
    data['colour'] = this.colour;
    data['plate_number'] = this.plateNumber;
    data['capacity'] = this.capacity;
    data['model'] = this.model;
    data['model_year'] = this.modelYear;
    data['brand'] = this.brand;
    data['license'] = this.license;
    return data;
  }
}
