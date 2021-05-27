import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/chat.dart';
import 'package:wemoove/models/message.dart';
import 'package:wemoove/services/UserServices.dart';

class ChatController extends BaseViewModel {
  ably.Realtime realtimeInstance;
  var messageData;
  ably.RealtimeChannel chatChannel;
  TextEditingController messageController = TextEditingController();
  var myRandomClientId = "1";
  String channel;
  int recipient;
  String replyingto;
  int msgindex;
  int rideId;

  List<Message> messages = [];

  init(dynamic rideId, int recipient) {
    channel = "chat-ride${rideId}";
    this.rideId = rideId;
    createAblyRealtimeInstance(channel);
    this.recipient = recipient;
    fetchChats();
    markChatAsRead();
    //notifyListeners();
  }

  destroy() {
    channel = null;
    this.recipient = null;
    this.rideId = null;
    realtimeInstance = null;
    chatChannel.detach();
    this.messages.clear();
  }

  String parseDate(String date) {
    DateTime parsedDate = DateTime.tryParse(date);
    return formatDate(parsedDate);
  }

  String formatDate(DateTime date) => new DateFormat("d MMM y").format(date);

  fetchChats() async {
    var data = {
      "sender": globals.user.id,
      "receiver": recipient,
      'ride_id': rideId,
    };
    var chats = await UserServices.fetchChat(data, globals.token);
    if (chats is List<Chat> && chats.length != null) {
      SerializeChats(chats);
    }
    print(chats.length);
  }

  void markChatAsRead() async {
    var data = {
      "sender": recipient,
      "receiver": globals.user.id,
      'ride_id': rideId,
    };
    var response = await UserServices.markasread(data, globals.token);
    print(response);
  }

  void SerializeChats(List<Chat> chats) {
    for (var chat in chats) {
      Message msg = new Message(
          sender: "",
          senderid: chat.sender,
          recipient: chat.receiver,
          replyto: chat.replyto != null ? chat.replyto : "",
          replyindex: chat.replytoIndex != null ? chat.replytoIndex : -1,
          text: chat.message,
          isByMe: chat.sender == globals.user.id ? true : false,
          time: chat.time,
          date: parseDate(chat.createdAt));
      messages.add(msg);
    }
    notifyListeners();
  }

  void reply(String msg, int index) {
    replyingto = msg;
    msgindex = index;
    notifyListeners();
  }

  void cancelReply() {
    replyingto = "";
    msgindex = null;
    notifyListeners();
  }

  void createAblyRealtimeInstance(String channel) async {
    //var uuid = Uuid();
    //myRandomClientId = uuid.v4();
    var clientOptions =
        ably.ClientOptions.fromKey("LMmBUQ.zIOpdQ:0yUBg-ANfdk5L5HX");
    clientOptions.clientId = myRandomClientId;
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      print('Ably instantiated');
      chatChannel = realtimeInstance.channels.get(channel);
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
    var messageStream = chatChannel.subscribe();
    messageStream.listen((ably.Message message) {
      Message newChatMsg;
      messageData = message.data;
      if ((messageData["recipient"].toInt() == globals.user.id &&
              messageData["senderId"].toInt() == recipient) ||
          (messageData["senderId"].toInt() == globals.user.id &&
                  messageData["recipient"].toInt() == recipient) &&
              messageData != null) {
        print("New message arrived ${message.data}");
        var hoursIn12HrFormat = message.timestamp.hour > 12
            ? (message.timestamp.hour - 12)
            : (message.timestamp.hour);
        var timeOfDay = message.timestamp.hour < 12 ? ' AM' : ' PM';
        var msgTime = hoursIn12HrFormat.toString() +
            ":" +
            message.timestamp.minute.toString() +
            timeOfDay;
        newChatMsg = Message(
          sender: "",
          time: msgTime,
          text: messageData["msg"],
          isByMe: messageData["senderId"] == globals.user.id ? true : false,
          senderid: messageData["senderId"],
          recipient: messageData["recipient"],
          replyindex:
              messageData["msgindex"] != null ? messageData["msgindex"] : null,
          replyto: messageData["replyto"] != null ? messageData["replyto"] : "",
          date: formatDate(DateTime.now()),
          unread: false,
        );
        messages.add(newChatMsg);
        messageData = null;
        notifyListeners();
        markChatAsRead();
      }
    });
  }

  void publishMyMessage(dynamic recipient) async {
    DateTime time = DateTime.now();
    var myMessage = messageController.text;
    messageController.clear();
    chatChannel.publish(name: "chatMsg", data: {
      "sender": globals.user.fullName,
      "senderId": globals.user.id,
      "recipient": recipient,
      "msg": myMessage,
      "replyto": replyingto != null ? replyingto : "",
      "msgindex": msgindex != null ? msgindex : -1
    });

    toast('Message Sent');

    var hoursIn12HrFormat = time.hour > 12 ? (time.hour - 12) : (time.hour);
    var timeOfDay = time.hour < 12 ? ' AM' : ' PM';

    var msgTime =
        hoursIn12HrFormat.toString() + ":" + time.minute.toString() + timeOfDay;
    var data = {
      "sender": globals.user.id,
      "reciever": recipient,
      'read': "1",
      'ride_id': rideId,
      'message': myMessage,
      'replyto': replyingto,
      'replytoIndex': msgindex != null ? msgindex : null,
      'time': msgTime
    };
    cancelReply(); //this is just to clear the variables after
    UserServices.saveChat(data, globals.token);
  }
}
