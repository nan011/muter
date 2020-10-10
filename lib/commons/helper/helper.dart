import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

typedef ColorSetter = Color Function(double opacity);

class AppColor {
  static ColorSetter black = Utility.getColorSetter("#535353");
  static ColorSetter white = Utility.getColorSetter("#FFFFFF");
  static ColorSetter blue = Utility.getColorSetter("#134B66");
  static ColorSetter red = Utility.getColorSetter("#E60B64");
  static ColorSetter grayLighter = Utility.getColorSetter("#F8F8F8");
  static ColorSetter grayLight = Utility.getColorSetter("#EDEDED");
  static ColorSetter gray = Utility.getColorSetter("#C4C4C4");
}

class AppShadow {
  static BoxShadow normalShadow = BoxShadow(
    color: Utility.color("#000000", 0.06),
    blurRadius: 100,
    spreadRadius: 4,
    offset: Offset(0, 0), // changes position of shadow
  );

  static BoxShadow hardShadow = BoxShadow(
    color: Utility.color("#000000", 0.08),
    blurRadius: 100,
    spreadRadius: 4,
    offset: Offset(0, 0), // changes position of shadow
  );
}

class Utility {
  static const String APP_ID_KEY = "APP_ID_KEY";
  static Future<String> getAppId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appId = prefs.getString(APP_ID_KEY);

    if (appId == null) {
      appId = Uuid().v4();
      prefs.setString(APP_ID_KEY, appId);
    }

    return appId;
  }

  static double distanceTwoPointsOnEarth(Offset startPoint, Offset endPoint) {
    Offset startPointInRadian =
        Offset(radians(startPoint.dx), radians(startPoint.dy));
    Offset endPointInRadian =
        Offset(radians(endPoint.dx), radians(endPoint.dy));

    Offset vector = endPointInRadian - startPointInRadian;

    double a = pow(sin(vector.dx / 2), 2) +
        cos(startPointInRadian.dx) *
            cos(endPointInRadian.dx) *
            pow(sin(vector.dy / 2), 2);

    double c = 2 * asin(sqrt(a));
    double r = 6731;
    return c * r;
  }

  static void goToAnotherPageOrStay(BuildContext context, String routeName) {
    bool hasSameDestinationAsCurrent = false;
    Navigator.of(context).popUntil((route) {
      hasSameDestinationAsCurrent = route.settings.name == routeName;
      return true;
    });

    if (!hasSameDestinationAsCurrent) {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  static ColorSetter getColorSetter(String hexColor) {
    return ([double opacity = 1]) => Utility.color(hexColor, opacity);
  }

  static Color color(String colorCode, [double opacity = 1]) {
    assert(0 <= opacity && opacity <= 1);
    assert(colorCode[0] == '#');

    int opacityHex = (255 * opacity).toInt() * 0x01000000;
    int colorHex = int.parse(colorCode.substring(1, 7), radix: 16);
    return Color(colorHex + opacityHex);
  }
}

class LocationService {
  static Location _location = Location();
  static Future<Location> getService() async {
    await enableService();
    await grantPermission();
    return _location;
  }

  static bool _serviceIsEnabled = false;
  static bool isServiceEnabled() => _serviceIsEnabled;

  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static PermissionStatus permissionStatus() => _permissionStatus;

  static Future enableService() async {
    if (_serviceIsEnabled) return;

    _serviceIsEnabled = await _location.serviceEnabled();
    if (_serviceIsEnabled) return;

    while (!_serviceIsEnabled) {
      _serviceIsEnabled = await _location.requestService();
    }
  }

  static Future grantPermission() async {
    if (_permissionStatus == PermissionStatus.deniedForever ||
        _permissionStatus == PermissionStatus.granted) return;

    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.deniedForever ||
        _permissionStatus == PermissionStatus.granted) {
      return;
    }

    while (_permissionStatus != PermissionStatus.granted) {
      _permissionStatus = await _location.requestPermission();
    }
  }
}

class LocalNotificationService {
  static Map<String, List<VoidCallback>> _notificationListeners = {};

  static FlutterLocalNotificationsPlugin _flutterNotificationPlugin;
  static FlutterLocalNotificationsPlugin get plugin {
    if (_flutterNotificationPlugin == null) {
      AndroidInitializationSettings androidSetting =
          AndroidInitializationSettings("app_icon");
      IOSInitializationSettings iosSetting = IOSInitializationSettings();
      InitializationSettings setting =
          InitializationSettings(androidSetting, iosSetting);
      _flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
      _flutterNotificationPlugin.initialize(setting,
          onSelectNotification: _onSelectNotification);
    }

    return _flutterNotificationPlugin;
  }

  static addNotificationListener(String key, VoidCallback callback) {
    if (_notificationListeners[key] == null) {
      _notificationListeners[key] = <VoidCallback>[];
    }
    _notificationListeners[key].add(callback);
  }

  static Future<bool> _onSelectNotification(String key) async {
    if (_notificationListeners[key] == null) return true;

    _notificationListeners[key].forEach((VoidCallback callback) {
      callback();
    });

    return true;
  }
}

class SubscriptionManager {
  static final Map<String, StreamSubscription> _streamSubscriptions = {};
  static bool isActive(String id) => _streamSubscriptions[id] != null;

  static bool add(String id, StreamSubscription subscription) {
    if (_streamSubscriptions[id] == null) {
      _streamSubscriptions[id] = subscription;
      return true;
    }
    return false;
  }

  static bool stop(String id) {
    if (_streamSubscriptions[id] != null) {
      _streamSubscriptions[id].cancel();
      _streamSubscriptions[id] = null;
      return true;
    }
    return false;
  }
}

class ActiveStationNotification {
  static List<int> _originalDistanceList = List<int>();
  static List<int> get originalDistanceList =>
      []..addAll(_originalDistanceList);

  static List<int> _activeDistanceList = List<int>();
  static List<int> get activeDistanceList => []..addAll(_activeDistanceList);

  static Map<String, dynamic> _station;
  static Map<String, dynamic> get station => _station;

  static const String STREAM_SUBSCRIPTION_KEY = "STATION_NOTIFICATION";

  static bool isActive() => _station != null;

  static List<VoidCallback> _listeners = <VoidCallback>[];
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void _notify() {
    _listeners.forEach((VoidCallback listener) => listener());
  }

  static Future set({
    BuildContext context,
    int stationId,
    List<int> distanceList,
  }) async {
    _originalDistanceList = []..addAll(distanceList);
    _originalDistanceList.sort((int a, int b) => a.compareTo(b));
    _activeDistanceList = []..addAll(_originalDistanceList);

    List<dynamic> stations = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/data/station_coords.json'));
    int stationIndex =
        stations.indexWhere((station) => station["id"] == stationId);
    _station = stations[stationIndex];

    FlutterLocalNotificationsPlugin plugin = LocalNotificationService.plugin;
    AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
      "Channel ID",
      "Channel Title",
      "Channel Description",
      priority: Priority.Low,
      enableVibration: false,
    );

    IOSNotificationDetails iosDetail = IOSNotificationDetails();
    NotificationDetails notificationDetail = NotificationDetails(
      androidDetail,
      iosDetail,
    );

    var location = await LocationService.getService();
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 500,
    );

    StreamSubscription locationSubscription = location.onLocationChanged.listen(
      (LocationData currentLocation) async {
        if (_activeDistanceList.isEmpty) {
          _notify();
          clear();
          return;
        }

        Offset currentPosition = Offset(
          currentLocation.latitude,
          currentLocation.longitude,
        );

        Offset stationPosition = Offset(
          _station["coord"]["latitude"],
          _station["coord"]["longitude"],
        );

        int currentDistance = (Utility.distanceTwoPointsOnEarth(
                  currentPosition,
                  stationPosition,
                ) *
                1000)
            .toInt();

        if (_activeDistanceList.last >= currentDistance) {
          int lastDistance = _activeDistanceList.removeLast();
          await VibrationSetting.vibrate();
          await plugin.show(
            0,
            tr("alert_notif_gettingclose"),
            sprintf(tr("alert_notif_gettingclose_distance"), [
              lastDistance,
            ]),
            notificationDetail,
          );
          _notify();
        }
      },
    );
    SubscriptionManager.add(
      STREAM_SUBSCRIPTION_KEY,
      locationSubscription,
    );
  }

  static void clear() {
    SubscriptionManager.stop(
      STREAM_SUBSCRIPTION_KEY,
    );
    _station = null;
    _listeners = <VoidCallback>[];
  }
}

class VibrationSetting {
  static const int MIN_DURATION = 1000;
  static const int MAX_DURATION = 5000;
  static int _duration = MIN_DURATION;
  static int get duration => _duration;
  static set duration(int newDuration) {
    if (newDuration >= MIN_DURATION && newDuration <= MAX_DURATION) {
      _duration = newDuration;
    }
  }

  static const int MIN_AMPLITUDE = 0;
  static const int MAX_AMPLITUDE = 150;
  static int _amplitude = MIN_AMPLITUDE;
  static int get amplitude => _amplitude;
  static set amplitude(int newAmplitude) {
    if (newAmplitude >= MIN_AMPLITUDE && newAmplitude <= MAX_AMPLITUDE) {
      _amplitude = newAmplitude;
    }
  }

  static const int REPEAT_DELAY = 500;
  static const int MIN_REPEAT_COUNT = 1;
  static const int MAX_REPEAT_COUNT = 5;
  static int _repeatCount = MIN_REPEAT_COUNT;
  static int get repeatCount => _repeatCount;
  static set repeatCount(int newRepeatCount) {
    if (newRepeatCount >= MIN_REPEAT_COUNT &&
        newRepeatCount <= MAX_REPEAT_COUNT) {
      _repeatCount = newRepeatCount;
    }
  }

  static const int MIN_REPEAT_DELAY = 100;
  static const int MAX_REPEAT_DELAY = 2000;
  static int _repeatDelay = MIN_REPEAT_DELAY;
  static int get repeatDelay => _repeatDelay;
  static set repeatDelay(int newRepeatDelay) {
    if (newRepeatDelay >= MIN_REPEAT_DELAY &&
        newRepeatDelay <= MAX_REPEAT_DELAY) {
      _repeatDelay = newRepeatDelay;
    }
  }

  static bool _hasOpened = false;

  static bool _hasVibrator;
  static bool get hasVibrator => _hasVibrator;

  static bool _hasAmplitudeControl;
  static bool get hasAmplitudeControl => _hasAmplitudeControl;

  static Future<Null> open() async {
    _hasOpened = true;
    _hasVibrator = await Vibration.hasVibrator();

    if (!_hasVibrator) {
      _hasAmplitudeControl = false;
      return;
    }

    _hasAmplitudeControl = await Vibration.hasAmplitudeControl();
  }

  static String categorizeAmplitude() {
    if (_amplitude > 100) {
      return 'High';
    } else if (_amplitude > 50) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  static Future<Null> vibrate() async {
    if (!_hasOpened) {
      await open();
    }

    int amplitude = -1;
    if (_hasAmplitudeControl) {
      amplitude = _amplitude;
    }

    List<int> pattern = [0]..addAll(
        List<int>.generate(_repeatCount, (index) => _duration).fold<List<int>>(
          <int>[],
          (List<int> pattern, int duration) {
            pattern.addAll([
              _duration,
              _repeatDelay,
            ]);
            return pattern;
          },
        ),
      );

    await Vibration.vibrate(
      amplitude: amplitude,
      pattern: pattern,
    );

    await Future.delayed(
      Duration(
        milliseconds: pattern.fold<int>(
          0,
          (int total, int time) {
            return total + time;
          },
        ),
      ),
    );
  }
}

class Account {
  static String name;
  static AvatarIcon icon;
}

class PushMessageCooldown {
  static int _cooldown = 0;
  static get cooldown => _cooldown;
  static set cooldown(int newCooldown) {
    if (newCooldown >= 0.0) {
      _cooldown = newCooldown;

      listeners.forEach((listener) => listener());
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        _cooldown -= 1;
        listeners.forEach((listener) => listener());

        if (_cooldown == 0) timer.cancel();
      });
    }
  }

  static List<VoidCallback> listeners = [];
  static int addListener(VoidCallback listener) {
    listeners.add(listener);
    return listeners.length - 1;
  }

  static void removeListener(int index) {
    if (listeners.length <= index) return;
    listeners.removeAt(index);
  }
}
