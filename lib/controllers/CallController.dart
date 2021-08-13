import 'dart:math';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/views/Call/CallScreen.dart';
import 'package:wemoove/views/Call/incoming_call_screen.dart';

class CallController extends BaseViewModel {
  ably.Realtime realtimeInstance;
  var messageData;
  ably.RealtimeChannel callChannel;
  var ClientId = globals.user.id;
  String channel;
  String agoraChannel;
  String token;
  String appId;
  int recipient;
  int rideId;
  bool isConnected = false;
  bool isRejected = false;
  bool isEnded = false;
  bool isCalling = false;

  init() {
    channel = "callChannel";
    createAblyRealtimeInstance(channel);
  }

  String generateRandomString() {
    int length = 10;
    var rng = new Random();
    String characters =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    int charactersLength = characters.length;
    String randomString = '';
    for (int i = 0; i < length; i++) {
      randomString += characters[rng.nextInt(charactersLength - 1)];
    }
    print(randomString);
    return randomString;
  }

  destroy() {
    channel = null;
    realtimeInstance = null;
    callChannel.detach();
  }

  String parseDate(String date) {
    DateTime parsedDate = DateTime.tryParse(date);
    return formatDate(parsedDate);
  }

  String formatDate(DateTime date) => new DateFormat("d MMM y").format(date);

  void createAblyRealtimeInstance(String channel) async {
    var clientOptions =
        ably.ClientOptions.fromKey(globals.wemooveCallApiKeyAbly);
    clientOptions.clientId = ClientId.toString();
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      print('Ably instantiated');
      callChannel = realtimeInstance.channels.get(channel);
      subscribeToChatChannel();
      realtimeInstance.connection
          .on(ably.ConnectionEvent.connected)
          .listen((ably.ConnectionStateChange stateChange) async {
        print('Realtime connection state changed: ${stateChange.event}');
      });
    } catch (error) {
      print('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  void subscribeToChatChannel() {
    var messageStream =
        callChannel.subscribe(names: ["call", 'connected', 'end', 'hangup']);
    messageStream.listen((ably.Message message) {
      String CallEvent = message.name;
      messageData = message.data;
      String msg = messageData["msg"];
      bool byme = messageData["senderId"] == globals.user.id ? true : false;
      dynamic Callerid = messageData["senderId"];
      double recipient = messageData["recipient"];
      String caller = messageData["sender"];
      String profile = messageData['profile'];
      String channel = messageData['channel'];
      String appId = messageData['appId'];
      String token = messageData['token'];
      print(messageData);
      print(CallEvent);
      print(channel);
      print(appId);
      print(token);
      //If I am the Recipient
      //and the event is call
      //Show incoming
      if (CallEvent == "call" &&
          recipient.toInt() == globals.user.id &&
          isConnected != true) {
        globals.callController.token = token;
        globals.callController.appId = appId;
        globals.callController.agoraChannel = channel;
        globals.callController.isCalling = true;
        Navigate.to(
            globals.context,
            IncomingCallScreen(
              callIsFromMe: false,
              profileUrl: profile,
              reciever: globals.user.fullName, // me
              caller: caller,
              channel: channel,
              callerId: Callerid,
              controller: this,
            ));
      }

      if (CallEvent == "hangup" && recipient.toInt() == globals.user.id) {
        globals.callController.token = "";
        globals.callController.appId = "";
        globals.callController.agoraChannel = "";
        globals.callController.isCalling = false;
        Navigator.pop(globals.context);
      }

      if (CallEvent == "end" && recipient.toInt() == globals.user.id) {
        if (globals.callController.isCalling) {
          Navigator.pop(globals.context);
          this.isCalling = false;
        }
      }

      if (CallEvent == "connected" &&
          (recipient.toInt() == globals.user.id ||
              Callerid.toInt() == globals.user.id)) {
        Navigator.pop(globals.context);
        print(globals.callController.agoraChannel);
        print(globals.callController.appId);
        print(globals.callController.token);
        Navigate.to(
            globals.context,
            JoinChannelAudio(
              appId: appId,
              channel: channel,
              token: token,
              recipient:
                  recipient.toInt() == globals.user.id ? Callerid : recipient,
              fullname: recipient.toInt() == globals.user.id
                  ? caller
                  : messageData["nameofRecipient"],
              callController: this,
            ));
      }
    });
  }

  void makeCall(dynamic recipientId, String profileImage,
      String recipientfullname) async {
    print(globals.calltoken.appID +
        " ID:TOKEN " +
        globals.calltoken.token +
        "CHANNEL" +
        globals.calltoken.channelName);
    DateTime time = DateTime.now();
    callChannel.publish(name: "call", data: {
      "sender": globals.user.fullName,
      "senderId": ClientId,
      "recipient": recipientId,
      "profile": globals.user.profileImage,
      "channel": globals.calltoken.channelName,
      "appId": globals.calltoken.appID,
      "token": globals.calltoken.token,
    });
    toast('Call Started');
    this.isCalling = true;
    Navigate.to(
        globals.context,
        IncomingCallScreen(
          callIsFromMe: true,
          profileUrl: profileImage,
          reciever: recipientfullname,
          caller: globals.user.fullName,
          channel: "sample channel",
          recipientId: recipientId,
          controller: this,
        ));
  }

  void pickUp(dynamic recipientId, String nameofRecipient) async {
    DateTime time = DateTime.now();
    callChannel.publish(name: "connected", data: {
      "sender": globals.user.fullName,
      "senderId": ClientId,
      "recipient": recipientId,
      "nameofRecipient": nameofRecipient,
      "profile": globals.user.profileImage,
      "channel": globals.callController.agoraChannel,
      "appId": globals.callController.appId,
      "token": globals.callController.token,
    });
  }

  void endCall(dynamic recieverId) async {
    this.token = "";
    this.appId = "";
    this.agoraChannel = "";
    globals.callController.isCalling = false;
    print("ending to " + recieverId.toString());
    callChannel.publish(name: "end", data: {
      "sender": globals.user.fullName,
      "senderId": ClientId,
      "recipient": recieverId,
      "channel": "N/A",
      "profile": "N/A",
      "appId": "N/A",
      "token": "N/A",
    });
    toast('Call Terminated');
  }

  void hangup(dynamic recieverId) async {
    globals.callController.token = "";
    globals.callController.appId = "";
    globals.callController.agoraChannel = "";
    globals.callController.isCalling = false;
    print("ending to " + recieverId.toString());
    callChannel.publish(name: "hangup", data: {
      "sender": globals.user.fullName,
      "senderId": ClientId,
      "recipient": recieverId,
      "channel": "N/A",
      "profile": "N/A",
      "appId": "N/A",
      "token": "N/A",
    });
    toast('Call Terminated');
  }
}
