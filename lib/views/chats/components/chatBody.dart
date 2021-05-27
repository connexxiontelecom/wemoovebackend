import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:wemoove/controllers/ChatController.dart';
import 'package:wemoove/models/message.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ChatBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  final ChatController controller;
  final dynamic recipient;
  final dynamic rideId;
  final String name;
  final dynamic picture;
  ChatBody(
      {Key key,
      this.scaffoldkey,
      this.controller,
      this.recipient,
      this.rideId,
      this.name,
      this.picture})
      : super(key: key);
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  bool up = false;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode focusnode;
  String replyingTo = "";
  int msgindex;
  ChatController chatBloc;
  ScrollController scrollcontroller = new ScrollController();

  refocus() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //focusnode.requestFocus();
      focusnode.unfocus();
      FocusScope.of(context).requestFocus(focusnode);
    });
  }

  scroll() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      scrollcontroller.animateTo(scrollcontroller.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    chatBloc.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scroll();
    chatBloc = Provider.of<ChatController>(context);
    focusnode = FocusNode();
    if (chatBloc.channel == null) {
      chatBloc.init(widget.rideId, widget.recipient);
    }
    chatBloc.markChatAsRead();
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    //return SizedBox.expand(
    return /*ViewModelBuilder<ChatController>.reactive(
        viewModelBuilder: () => controller,
        builder: (context, controller, child) =>*/
        Scaffold(
      backgroundColor: kprimarywhiteshade,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: getProportionateScreenHeight(100),
              decoration: BoxDecoration(
                  color: kPrimaryAlternateColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Icon(
                            LineAwesomeIcons.angle_left,
                            color: kPrimaryColor,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 23,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(widget.picture),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
              top: getProportionateScreenHeight(120),
              left: 15,
              right: 15,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollcontroller,
                      child: Column(
                        children: [
                          chatBloc.messages.length <= 0
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/error.png",
                                        height: 300,
                                      ),
                                      Text(
                                        "Start a Conversation",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: chatBloc.messages.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (index > 0 &&
                                        chatBloc.messages[index].date ==
                                            chatBloc.messages[index - 1].date) {
                                      return SwipeTo(
                                        onRightSwipe: () {
                                          /*OnSwiped(
                                            chatBloc.messages[index], index);*/

                                          chatBloc.reply(
                                              chatBloc.messages[index].text,
                                              index);
                                          refocus();
                                        },
                                        child: MessageContainer(
                                          chat: chatBloc.messages[index],
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                                child: Text(
                                              chatBloc.messages[index].date,
                                              style: TextStyle(fontSize: 17),
                                            )),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SwipeTo(
                                            onRightSwipe: () {
                                              /*OnSwiped(
                                            chatBloc.messages[index], index);*/

                                              chatBloc.reply(
                                                  chatBloc.messages[index].text,
                                                  index);
                                              refocus();
                                            },
                                            child: MessageContainer(
                                              chat: chatBloc.messages[index],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      if (chatBloc.replyingto != null &&
                          chatBloc.replyingto.isNotEmpty &&
                          chatBloc.msgindex != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 2,
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(chatBloc.replyingto),
                                ),
                                GestureDetector(
                                  child: Icon(LineAwesomeIcons.times_circle),
                                  onTap: () {
                                    chatBloc.cancelReply();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextField(
                          controller: chatBloc.messageController,
                          maxLines: null,
                          focusNode: focusnode,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "Type a message",
                            suffix: InkWell(
                              child: Icon(
                                LineAwesomeIcons.paper_plane,
                                color: kTextColor,
                              ),
                              onTap: () {
                                chatBloc.publishMyMessage(widget.recipient);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
    //);
    //);
  }
}

class MessageContainer extends StatelessWidget {
  final Message chat;
  const MessageContainer({
    Key key,
    this.chat,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      alignment: chat.isByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0xffb0cce1).withOpacity(0.5),
              ),
            ],
            color: chat.isByMe ? kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight:
                    chat.isByMe ? Radius.circular(0) : Radius.circular(30),
                bottomLeft:
                    chat.isByMe ? Radius.circular(30) : Radius.circular(0),
                bottomRight:
                    chat.isByMe ? Radius.circular(30) : Radius.circular(30))),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (chat.replyto.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: chat.isByMe
                          ? kVariationColor
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 2, color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SelectableText(chat.replyto),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SelectableText(
                chat.text,
                style: TextStyle(
                    color:
                        chat.isByMe ? kPrimaryAlternateColor : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              //Text(chat.date),
              Text(
                chat.time,
                style: TextStyle(
                    color: chat.isByMe ? Colors.white : Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
