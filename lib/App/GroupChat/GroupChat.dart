import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/Header/Header.dart';

class GroupChat extends StatefulWidget {
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
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
              icon: args.isTransition
                  ? AvatarIcon.transitionStation
                  : AvatarIcon.normalStation,
              radius: 38,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                args.name,
                style: TextStyle(
                  color: AppColor.blue(1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                children: [
                  GroupChatPerson(
                    name: "Awesome Rabbit",
                    message:
                        "Katanya di deket stasiun UI ada kereta yang ga jalan ya?",
                    date: DateTime.now(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                  ),
                  GroupChatMe(
                    message: "Iyanih anjing!",
                    date: DateTime.now(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                  ),
                  GroupChatPerson(
                    name: "Pejuang SBMPTN Gan",
                    message: "Ah anjay!",
                    date: DateTime.now(),
                  ),
                ],
              ),
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
                            hintText: "Message...",
                          ),
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
                        print("print");
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
  final int id;
  final String name;
  final bool isTransition;

  GroupChatArguments({
    this.id,
    this.name,
    this.isTransition,
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
  final String name;
  final String message;
  final DateTime date;

  GroupChatPerson({
    Key key,
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
          icon: AvatarIcon.koala,
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
                  Container(
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
        Container(
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
      ],
    );
  }
}
