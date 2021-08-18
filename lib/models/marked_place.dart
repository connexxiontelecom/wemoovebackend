class MarkedPlace {
  //Location points;
  String place = "ChIJL3W5c0IKThAROqEfOKvXokE";
  String name;

  MarkedPlace({this.name, this.place /*this.points*/});

  MarkedPlace.fromJson(Map<String, dynamic> json) {
    /* points =
        json['points'] != null ? new Location.fromJson(json['geometry']) : null;*/
    place = json['place'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*if (this.points != null) {
      data['points'] = this.points.toJson();
    }*/
    data['place'] =
        this.place != null ? this.place : "ChIJL3W5c0IKThAROqEfOKvXokE";
    data['name'] = this.name;
    return data;
  }
}
