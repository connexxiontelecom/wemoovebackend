import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/CallController.dart';
import 'package:wemoove/globals.dart' as globals;

/// JoinChannelAudio Example
class JoinChannelAudio extends StatefulWidget {
  final String channel;
  final String appId;
  final String token;
  final String fullname;
  final dynamic recipient;
  final CallController callController;
  const JoinChannelAudio(
      {Key key,
      this.channel,
      this.appId,
      this.token,
      this.callController,
      this.fullname,
      this.recipient})
      : super(key: key);
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  bool isLoudSpeaker = false;
  bool isMute = false;
  RtcEngine _engine;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 0, _playbackVolume = 0, _inEarMonitoringVolume = 0;
  @override
  void initState() {
    super.initState();
    this._initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(widget.appId));
    this._addListeners();
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    this._joinChannel();
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        log('joinChannelSuccess ${channel} ${uid} ${elapsed}');
        setState(() {
          isJoined = true;
        });
      },
      leaveChannel: (stats) async {
        log('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine
        .joinChannel(widget.token, widget.channel, null, 0)
        .catchError((onError) {
      print('error ${onError.toString()}');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }

  _switchEffect() async {
    if (playEffect) {
      _engine.stopEffect(1).then((value) {
        setState(() {
          playEffect = false;
        });
      }).catchError((err) {
        log('stopEffect $err');
      });
    } else {
      _engine
          .playEffect(
              1,
              await (_engine.getAssetAbsolutePath("assets/Sound_Horizon.mp3")
                  as FutureOr<String>),
              -1,
              1,
              1,
              100,
              true)
          .then((value) {
        setState(() {
          playEffect = true;
        });
      }).catchError((err) {
        log('playEffect $err');
      });
    }
  }

  _onChangeInEarMonitoringVolume(double value) {
    setState(() {
      _inEarMonitoringVolume = value;
    });
    _engine.setInEarMonitoringVolume(value.toInt());
  }

  _toggleInEarMonitoring(value) {
    setState(() {
      _enableInEarMonitoring = value;
    });
    _engine.enableInEarMonitoring(value);
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
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(widget.fullname, style: TextStyle(fontSize: 25)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 8),
                child: Text("Connected", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 20,
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
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      heroTag: "Mute",
                      child: Icon(
                        isMute ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        this._switchMicrophone();
                        setState(() {
                          isMute = !isMute;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      heroTag: "RejectCall",
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        this._leaveChannel();
                        widget.callController.hangup(widget.recipient);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: FloatingActionButton(
                      heroTag: "loudspeaker",
                      child: Icon(
                        isLoudSpeaker ? Icons.volume_up : Icons.volume_down,
                        color: Colors.white,
                      ),
                      backgroundColor: kPrimaryColor,
                      onPressed: () {
                        this._switchSpeakerphone();
                        setState(() {
                          isLoudSpeaker = !isLoudSpeaker;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

/*  Widget build(BuildContext context) {

   /* return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Text("${widget.channel}"),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed:
                            isJoined ? this._leaveChannel : this._joinChannel,
                        child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: this._switchMicrophone,
                        child:
                            Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
                      ),
                      ElevatedButton(
                        onPressed: this._switchSpeakerphone,
                        child: Text(
                            enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
                      ),
                      ElevatedButton(
                        onPressed: this._switchEffect,
                        child: Text('${playEffect ? 'Stop' : 'Play'} effect'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('RecordingVolume:'),
                          Slider(
                            value: _recordingVolume,
                            min: 0,
                            max: 400,
                            divisions: 5,
                            label: 'RecordingVolume',
                            onChanged: (double value) {
                              setState(() {
                                _recordingVolume = value;
                              });
                              _engine
                                  .adjustRecordingSignalVolume(value.toInt());
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('PlaybackVolume:'),
                          Slider(
                            value: _playbackVolume,
                            min: 0,
                            max: 400,
                            divisions: 5,
                            label: 'PlaybackVolume',
                            onChanged: (double value) {
                              setState(() {
                                _playbackVolume = value;
                              });
                              _engine.adjustPlaybackSignalVolume(value.toInt());
                            },
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('InEar Monitoring Volume:'),
                            Switch(
                              value: _enableInEarMonitoring,
                              onChanged: _toggleInEarMonitoring,
                              activeTrackColor: Colors.grey[350],
                              activeColor: Colors.white,
                            )
                          ]),
                          if (_enableInEarMonitoring)
                            Container(
                                width: 300,
                                child: Slider(
                                  value: _inEarMonitoringVolume,
                                  min: 0,
                                  max: 100,
                                  divisions: 5,
                                  label: 'InEar Monitoring Volume',
                                  onChanged: _onChangeInEarMonitoringVolume,
                                ))
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                ))
          ],
        ),
      ),
    );*/
  }*/
}
