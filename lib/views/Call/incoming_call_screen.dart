import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:wemoove/controllers/CallController.dart';
import 'package:wemoove/globals.dart' as globals;

class IncomingCallScreen extends StatefulWidget {
  final bool callIsFromMe;
  final String profileUrl;
  final String reciever;
  final String channel;
  final String caller;
  final dynamic callerId;
  final dynamic recipientId;
  final CallController controller;

  const IncomingCallScreen(
      {Key key,
      this.callIsFromMe = false,
      this.profileUrl = "",
      this.reciever = "",
      this.channel = "",
      this.controller,
      this.caller,
      this.callerId,
      this.recipientId})
      : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  Timer _timer;
  void initState() {
    super.initState();
    //To Play Ringtone
    if (widget.callIsFromMe == false) {
      FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.electronic,
          looping: true,
          volume: 0.5,
          asAlarm: false);
      _timer = Timer(const Duration(milliseconds: 60 * 1000), endCall);
    }
  }

  endCall() {
    if (widget.callIsFromMe == false) {
      widget.controller.endCall(widget.callerId);
      FlutterRingtonePlayer.stop();
      _timer.cancel();
    } else {
      widget.controller.endCall(widget.recipientId);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    //To Stop Ringtone
    FlutterRingtonePlayer.stop();
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
            body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("Calling", style: TextStyle(fontSize: 28)),
              ),
              widget.controller.isConnected
                  ? Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text("Connected", style: TextStyle(fontSize: 20)),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 8),
                      child: Text("Connecting", style: TextStyle(fontSize: 20)),
                    ),
              Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Text(
                    widget.callIsFromMe ? widget.reciever : widget.caller,
                    style: TextStyle(fontSize: 18)),
              ),
              CircleAvatar(
                  radius: 50,
                  //child: Image.asset("assets/images/sample.jpg")
                  backgroundImage: globals.user.profileImage.isEmpty
                      ? AssetImage("assets/images/portrait.png")
                      : NetworkImage(globals.user.profileImage)),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.callIsFromMe
                      ? FloatingActionButton(
                          heroTag: "End Call",
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.red,
                          onPressed: () {
                            //Navigator.pop(context);
                            endCall();
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 36),
                          child: FloatingActionButton(
                            heroTag: "RejectCall",
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                            onPressed: () {
                              endCall();
                            },
                          ),
                        ),
                  if (!widget.callIsFromMe)
                    Padding(
                      padding: EdgeInsets.only(left: 36),
                      child: FloatingActionButton(
                        heroTag: "AcceptCall",
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.green,
                        onPressed: () {
                          widget.controller
                              .pickUp(widget.callerId, widget.caller);
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        )));
  }
}
