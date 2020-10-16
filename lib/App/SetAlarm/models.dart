import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:muter/commons/helper/helper.dart';

class CurrentDistanceModel extends ChangeNotifier {
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> _locationSubscription;

  String _name;
  String get name => this._name;
  set name(String name) {
    this._name = name;
    notifyListeners();
  }

  double _latitude;
  double _longitude;
  Map<String, double> get coord {
    return {
      "latitude": this._latitude,
      "longitude": this._longitude,
    };
  }

  void setCoord(double latitude, double longitude) {
    if (latitude != null) {
      this._latitude = latitude;
    }

    if (longitude != null) {
      this._longitude = longitude;
    }
    notifyListeners();
  }

  int _currentDistance;
  int get currentDistance => this._currentDistance;

  void listenCurrentLocation() async {
    var location = await LocationService.getService();

    this._locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      Offset currentPosition = Offset(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      Offset stationPosition = Offset(
        this._latitude ?? currentPosition.dx,
        this._longitude ?? currentPosition.dy,
      );

      this._currentDistance = (Utility.distanceTwoPointsOnEarth(
                currentPosition,
                stationPosition,
              ) *
              1000)
          .toInt();
      notifyListeners();
    });
  }

  void stopListen() {
    if (this._locationSubscription != null) this._locationSubscription.cancel();
  }

  static CurrentDistanceModel createInstance({
    String name = "",
    double latitude,
    double longitude,
  }) {
    CurrentDistanceModel model = CurrentDistanceModel(
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
    model.listenCurrentLocation();
    return model;
  }

  CurrentDistanceModel({
    String name = "",
    double latitude,
    double longitude,
  }) {
    this._name = name;
    this._latitude = latitude;
    this._longitude = longitude;
  }
}

class DistanceListModel extends ChangeNotifier {
  Set<int> _distanceList = Set<int>();
  Set<int> get distanceList => this._distanceList;

  List<Map<String, dynamic>> _checkedDistances = [
    {
      'distance': 100,
      'isChecked': false,
    },
    {
      'distance': 300,
      'isChecked': false,
    },
    {
      'distance': 400,
      'isChecked': false,
    },
    {
      'distance': 700,
      'isChecked': false,
    },
  ];
  List<Map<String, dynamic>> get checkedDistances => this._checkedDistances;

  bool ableToAddDistance(
    BuildContext context,
    int distance,
  ) {
    if (this._distanceList.contains(distance)) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(tr("notif_checkeddistance_alert")),
        ),
      );
      return false;
    }
    return true;
  }

  bool addDistance(
    BuildContext context,
    int distance,
    bool isChecked,
  ) {
    if (isChecked && !ableToAddDistance(context, distance)) return false;

    this._distanceList.add(distance);
    this._checkedDistances.add(
      <String, dynamic>{
        'distance': distance,
        'isChecked': isChecked,
      },
    );
    notifyListeners();
    return true;
  }

  bool updateDistance(
    BuildContext context,
    int index,
    int distance,
    bool isChecked,
  ) {
    if (isChecked && !ableToAddDistance(context, distance)) return false;

    if (!isChecked && index > 4 - 1) {
      this._checkedDistances.removeAt(index);
    } else {
      this._checkedDistances[index]['isChecked'] = isChecked;
    }
    notifyListeners();

    if (isChecked) {
      this._distanceList.add(distance);
    } else {
      this._distanceList.remove(distance);
    }

    return true;
  }
}

class NewDistanceModel extends ChangeNotifier {
  int _newDistance;
  int get newDistance => _newDistance;
  set newDistance(int newValue) {
    this._newDistance = newValue;
    notifyListeners();
  }

  NewDistanceModel({
    int distance,
  }) {
    this._newDistance = distance;
  }
}
