import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:muter/App/SetAlarm/SetAlarm.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/GroupList/GroupList.dart';
import 'package:muter/commons/widgets/Item/Item.dart';
import 'package:muter/commons/widgets/SearchBar/SearchBar.dart';

class TrainNotification extends StatefulWidget {
  @override
  _TrainNotificationState createState() => _TrainNotificationState();
}

class _TrainNotificationState extends State<TrainNotification> {
  GlobalKey searchBarKey;
  double bodyHeight;
  List<dynamic> originalStations = [];
  List<dynamic> stations = [];

  @override
  void initState() {
    super.initState();

    this.searchBarKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ActiveStationNotification.isActive()) {
        Map<String, dynamic> station = ActiveStationNotification.station;
        await goToStationPage(SetAlarmArguments(
          id: station["id"],
          name: station["name"],
          isTransition: station["is_transition"],
          longitude: station["coord"]["longitude"],
          latitude: station["coord"]["latitude"],
        ));

        if (ActiveStationNotification.isActive()) {
          Navigator.of(context).popAndPushNamed("/Home");
          return;
        }
      }

      // Get body height after first render
      RenderBox bodyBox = this.searchBarKey.currentContext.findRenderObject();
      Offset bodyOffset = bodyBox.localToGlobal(Offset.zero);

      // Get station data
      setStationData();

      // Set all new data
      setState(() {
        bodyHeight = MediaQuery.of(context).size.height - bodyOffset.dy;
      });
    });
  }

  Future setStationData() async {
    List<dynamic> stations = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/data/station_coords.json'));

    if (mounted) {
      setState(() {
        this.originalStations = stations
          ..sort(
              (a, b) => (a["name"] as String).compareTo(b["name"] as String));
        this.stations = []..addAll(this.originalStations);
      });
    }
  }

  Future goToStationPage(SetAlarmArguments arguments) async {
    await Navigator.of(context).pushNamed(
      "/SetAlarm",
      arguments: arguments,
    );
  }

  int levenshteinSearch(String source, String pattern) {
    int m = source.length + 1;
    int n = pattern.length + 1;
    List<List<int>> distance =
        List<List<int>>.generate(m, (_) => List<int>.generate(n, (_) => 0));

    for (int i = 0; i < m; i++) {
      distance[i][0] = i;
    }

    for (int j = 0; j < n; j++) {
      distance[0][j] = j;
    }

    for (int j = 1; j < n; j++) {
      for (int i = 1; i < m; i++) {
        int substitutionCost = 0;
        if (source[i - 1] != pattern[j - 1]) {
          substitutionCost = 1;
        }

        distance[i][j] = [
          distance[i - 1][j] + 1,
          distance[i][j - 1] + 1,
          distance[i - 1][j - 1] + substitutionCost,
        ].reduce(min);
      }
    }

    return distance[m - 1][n - 1];
  }

  Future openStationNotification(Map<String, dynamic> station) async {
    SetAlarmArguments arguments = SetAlarmArguments(
      id: station["id"],
      name: station["name"],
      isTransition: station["is_transition"],
      longitude: station["coord"]["longitude"],
      latitude: station["coord"]["latitude"],
    );

    await goToStationPage(arguments);

    if (ActiveStationNotification.isActive()) {
      await goToStationPage(arguments);
      Navigator.of(context).popAndPushNamed("/Home");
    }
  }

  void filterStationBySimilarity(String pattern) {
    if (pattern == "") {
      setState(() {
        this.stations = []..addAll(this.originalStations);
      });
      return;
    }

    List<Map<String, dynamic>> stationDifferenceFactors =
        this.originalStations.map((station) {
      return <String, dynamic>{
        "station": station,
        "factor": levenshteinSearch(
            (station["name"] as String).toLowerCase(), pattern),
      };
    }).toList();

    stationDifferenceFactors
        .sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      return (a["factor"] as int).compareTo((b["factor"] as int));
    });

    setState(() {
      this.stations = stationDifferenceFactors.sublist(0, 10).map((data) {
        return data["station"];
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SearchBar(
              key: this.searchBarKey,
              hint: tr("stations_search_hint"),
              inRealTime: true,
              onSubmit: (String pattern) {
                this.filterStationBySimilarity(pattern);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 24,
            ),
          ),
          Container(
            height: bodyHeight ?? MediaQuery.of(context).size.height,
            child: ListView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: (90 + 100 + 20).toDouble(),
              ),
              children: [
                // Column(
                //   children: [
                //     GroupList(
                //       title: "Last Destinations",
                //       firstLimit: null,
                //       list: lastDestinations.map((destination) {
                //         return Item(
                //           name: destination['name'],
                //           onTap: () {
                //             Navigator.of(context).pushNamed('/SetAlarm');
                //           },
                //         );
                //       }).toList(),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(
                //         top: 24,
                //       ),
                //     ),
                //   ],
                // ),
                GroupList(
                  title: tr('stations_all_title'),
                  firstLimit: null,
                  list: this.stations.map((station) {
                    return Item(
                      icon: station["is_transition"]
                          ? AvatarIcon.transitionStation
                          : AvatarIcon.normalStation,
                      name: station['name'],
                      onTap: () => openStationNotification(station),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
