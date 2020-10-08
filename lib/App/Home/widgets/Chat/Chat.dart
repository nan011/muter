import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/App/GroupChat/GroupChat.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/GroupList/GroupList.dart';

List<Map<String, dynamic>> groupChats = [
  {
    'pair': ['Rangkas Bitung', 'Tanah Abang'],
  },
  {
    'pair': ['Tanah Abang', 'Duri'],
  },
  {
    'pair': ['Tanah Abang', 'Tangerang'],
  },
  {
    'pair': ['Duri', 'Kampung Bandan'],
  },
  {
    'pair': ['Kampung Bandan', 'Jatinegara'],
  },
  {
    'pair': ['Cikarang', 'Jatinegara'],
  },
  {
    'pair': ['Jatinegara', 'Manggarai'],
  },
  {
    'pair': ['Manggarai', 'Jakarta Kota'],
  },
  {
    'pair': ['Bogor', 'Citayam'],
  },
  {
    'pair': ['Nambo', 'Citayam'],
  },
  {
    'pair': ['Citayam', 'Manggarai'],
  },
  {
    'pair': ['Manggarai', 'Tanah Abang'],
  },
].map((Map<String, dynamic> groupChat) {
  String firstStation =
      ((groupChat['pair'] as List<String>)[0]).replaceAll(" ", "");
  String secondStation =
      ((groupChat['pair'] as List<String>)[1]).replaceAll(" ", "");
  return {
    ...groupChat,
    'id': "${firstStation}_$secondStation",
  };
}).toList();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      alignment: Alignment.center,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: 300,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: GroupList(
              title: tr('chat_livechat_title'),
              firstLimit: null,
              list: groupChats.map((Map<String, dynamic> groupChat) {
                return StationPairItem(
                  firstStationName: groupChat['pair'][0],
                  secondStationName: groupChat['pair'][1],
                  onTap: () {
                    GroupChatArguments args = GroupChatArguments(
                      id: groupChat["id"],
                      firstStationName: groupChat['pair'][0],
                      secondStationName: groupChat['pair'][1],
                    );
                    Navigator.of(context).pushNamed(
                      "/GroupChat",
                      arguments: args,
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class StationPairItem extends StatelessWidget {
  final VoidCallback onTap;
  final String firstStationName;
  final String secondStationName;

  StationPairItem({
    Key key,
    @required this.firstStationName,
    @required this.secondStationName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(
              icon: AvatarIcon.transitionStation,
              radius: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularBar(
                    label: firstStationName,
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
                      )),
                  CircularBar(
                    label: secondStationName,
                    backgroundColor: AppColor.red(1),
                    textColor: AppColor.white(1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularBar extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String label;

  CircularBar({
    Key key,
    @required this.backgroundColor,
    @required this.textColor,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Text(
        this.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
