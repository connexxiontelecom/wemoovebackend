class callToken {
  String token;
  String channelName;
  String appID;

  callToken({this.token, this.channelName, this.appID});

  callToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    channelName = json['channelName'];
    appID = json['appID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['channelName'] = this.channelName;
    data['appID'] = this.appID;
    return data;
  }
}
