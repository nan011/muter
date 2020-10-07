import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:muter/App/GroupChat/GroupChat.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/GroupList/GroupList.dart';
import 'package:muter/commons/widgets/Item/Item.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<dynamic> originalStations = <dynamic>[];
  List<dynamic> stations = <dynamic>[];

  @override
  void initState() {
    super.initState();
    setStations();
  }

  Future setStations() async {
    List<dynamic> stations = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/data/station_coords.json'));

    setState(() {
      this.originalStations = stations
        ..sort((a, b) => (a["name"] as String).compareTo(b["name"] as String));
      this.stations = []..addAll(this.originalStations);
    });
  }

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
              title: tr('stations_all_title'),
              firstLimit: null,
              list: this.stations.map((station) {
                return Item(
                  icon: station["is_transition"]
                      ? AvatarIcon.transitionStation
                      : AvatarIcon.normalStation,
                  name: station['name'],
                  onTap: () {
                    GroupChatArguments args = GroupChatArguments(
                      id: station["id"],
                      name: station["name"],
                      isTransition: station["is_transition"],
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
