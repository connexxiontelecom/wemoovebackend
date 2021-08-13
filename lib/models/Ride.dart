class Ride {
  int id;
  int driverId;
  String amount;
  String destination;
  String pickup1;
  String pickup2;
  List<String> dropoffs;
  List<Pickups> pickups;
  String departureTime;
  int capacity;
  int status;
  String createdAt;
  String updatedAt;
  int passengers;
  Driver driver;
  int takenSeats;

  Ride(
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
      this.passengers,
      this.driver,
      this.takenSeats});

  Ride.fromJson(Map<String, dynamic> json) {
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
    passengers = json['passengers'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    takenSeats = json['taken_seats'];
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
    data['passengers'] = this.passengers;
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    data['taken_seats'] = this.takenSeats;
    return data;
  }
}

class Pickups {
  String name;
  String place;
  String time;
  int seconds;
  String traveltime;

  Pickups({this.name, this.place, this.time, this.seconds, this.traveltime});

  Pickups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    place = json['place'];
    time = json['time'];
    seconds = json['seconds'];
    traveltime = json["traveltime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['place'] = this.place;
    data['time'] = this.time;
    data['seconds'] = this.seconds;
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
