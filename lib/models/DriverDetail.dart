class DriverDetails {
  int passengers;
  int rides;

  DriverDetails({this.passengers, this.rides});

  DriverDetails.fromJson(Map<String, dynamic> json) {
    passengers = json['passengers'];
    rides = json['rides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['passengers'] = this.passengers;
    data['rides'] = this.rides;
    return data;
  }
}
