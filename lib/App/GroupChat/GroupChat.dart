import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/App/Home/widgets/Chat/Chat.dart';

import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/Header/Header.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController chatInputController;
  Widget chatBox;
  Query collection;
  QueryDocumentSnapshot firstChatDoc;

  static const int NUMBER_OF_EACH_FETCH = 100;

  @override
  void initState() {
    super.initState();
    chatInputController = TextEditingController(text: "");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupFirestore();
    });
  }

  Future setupFirestore() async {
    await Firebase.initializeApp();
    final GroupChatArguments args = ModalRoute.of(context).settings.arguments;
    collection =
        FirebaseFirestore.instance.collection(args.id).orderBy("created_at");
    setChatBox();
  }

  Future setChatBox([bool shouldFetchNext = false]) async {
    if (collection == null) {
      return;
    }

    Stream<QuerySnapshot> chatStream;
    QuerySnapshot tempSnapshot = await collection.get();
    if (tempSnapshot.size > 0) {
      if (shouldFetchNext && firstChatDoc != null) {
        tempSnapshot = await collection
            .endAtDocument(firstChatDoc)
            .limitToLast(NUMBER_OF_EACH_FETCH)
            .get();
      } else if (!shouldFetchNext) {
        tempSnapshot = await collection.limitToLast(NUMBER_OF_EACH_FETCH).get();
      } else {
        return;
      }

      firstChatDoc = tempSnapshot.docs[0];
      chatStream = collection.startAtDocument(firstChatDoc).snapshots();
    } else {
      chatStream = collection.snapshots();
    }

    chatStream.listen((QuerySnapshot snapshot) {
      List<Widget> messages = snapshot.docs
          .map((DocumentSnapshot document) {
            String id = document.id;
            Map<String, dynamic> data = document.data();
            AvatarIcon icon =
                AvatarIcon.getIconByName(data['icon']) ?? AvatarIcon.rabbit;

            bool isMe = data["name"] == Account.name;

            return <Widget>[
              isMe
                  ? GroupChatMe(
                      message: data["message"],
                      date: DateTime.parse(data["created_at"]),
                    )
                  : GroupChatPerson(
                      key: Key(id),
                      icon: icon,
                      name: data["name"],
                      message: data["message"],
                      date: DateTime.parse(data["created_at"]),
                    ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
              ),
            ];
          })
          .expand((i) => i)
          .toList();
      Widget chatBox = RefreshIndicator(
        onRefresh: () async {
          if (tempSnapshot.size > 1) {
            await setChatBox(true);
          }
        },
        child: messages.length > 0
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return messages[index];
                },
              )
            : Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: Text(
                    tr("groupchat_nomessage"),
                    style: TextStyle(
                      color: AppColor.gray(1),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      );
      setState(() {
        this.chatBox = chatBox;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardShowing =
        MediaQuery.of(context).viewInsets.vertical > 0;
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    final GroupChatArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: Header(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
            ),
            Avatar(
              icon: AvatarIcon.transitionStation,
              radius: 38,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularBar(
                    label: args.firstStationName,
                    backgroundColor: AppColor.blue(1),
                    textColor: AppColor.white(1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: SvgPicture.asset(
                      "assets/arts/station-connector.svg",
                      height: 6,
                    ),
                  ),
                  CircularBar(
                    label: args.secondStationName,
                    backgroundColor: AppColor.red(1),
                    textColor: AppColor.white(1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/arts/line-wave.svg',
                  width: width * 0.35,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                  ),
                ),
                SvgPicture.asset(
                  'assets/arts/wave.svg',
                  height: 6,
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: chatBox == null
                  ? Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColor.blue(1)),
                      ),
                    )
                  : chatBox,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.white(1),
                boxShadow: [
                  AppShadow.normalShadow,
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: isKeyboardShowing ? 80 : null,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColor.black(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: tr("groupchat_messagehint"),
                          ),
                          controller: chatInputController,
                          style: TextStyle(
                            color: AppColor.black(1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (chatInputController.text.length == 0) {
                          return;
                        }

                        FirebaseFirestore.instance.collection(args.id).add({
                          'name': Account.name,
                          'icon': Account.icon.name,
                          'message': chatInputController.text,
                          'created_at': DateTime.now().toIso8601String()
                        });
                        chatInputController.text = "";
                      },
                      child: SvgPicture.asset(
                        "assets/icons/paper-plane.svg",
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupChatArguments {
  final String id;
  final String firstStationName;
  final String secondStationName;

  GroupChatArguments({
    @required this.id,
    @required this.firstStationName,
    @required this.secondStationName,
  });
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Widget child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key key,
    this.child,
    @required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}

class GroupChatPerson extends StatelessWidget {
  final AvatarIcon icon;
  final String name;
  final String message;
  final DateTime date;

  GroupChatPerson({
    Key key,
    @required this.icon,
    @required this.name,
    @required this.message,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(
          radius: 30,
          icon: icon,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 6,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: AppColor.blue(1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.grayLight(1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 8,
                        bottom: 8,
                        right: 16,
                      ),
                      child: Text(
                        this.message,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.black(1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 4,
                    ),
                  ),
                  Text(
                    "${date.hour}:${date.minute}",
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColor.gray(1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class GroupChatMe extends StatelessWidget {
  final String message;
  final DateTime date;

  GroupChatMe({
    Key key,
    @required this.message,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16,
          ),
        ),
        Text(
          "${date.hour}:${date.minute}",
          style: TextStyle(
            fontSize: 8,
            color: AppColor.gray(1),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 4,
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.blue(1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(
              top: 8,
              left: 16,
              bottom: 8,
              right: 8,
            ),
            child: Text(
              this.message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.white(1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
