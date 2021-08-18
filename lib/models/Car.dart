class Car {
  int id;
  int driverId;
  String colour;
  String plateNumber;
  int capacity;
  String model;
  String modelYear;
  String brand;
  dynamic license;
  String carPicture;
  String createdAt;
  String updatedAt;

  Car(
      {this.id,
      this.driverId,
      this.colour,
      this.plateNumber,
      this.capacity,
      this.model,
      this.modelYear,
      this.brand,
      this.license,
      this.carPicture,
      this.createdAt,
      this.updatedAt});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    colour = json['colour'];
    plateNumber = json['plate_number'];
    capacity = json['capacity'];
    model = json['model'];
    modelYear = json['model_year'];
    brand = json['brand'];
    license = json['license'];
    carPicture = json['car_picture'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['colour'] = this.colour;
    data['plate_number'] = this.plateNumber;
    data['capacity'] = this.capacity;
    data['model'] = this.model;
    data['model_year'] = this.modelYear;
    data['brand'] = this.brand;
    data['license'] = this.license;
    data['car_picture'] = this.carPicture;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
