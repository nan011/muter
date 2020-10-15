import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/App/SetAlarm/models.dart';

import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/Button/Button.dart';
import 'package:muter/commons/widgets/CheckboxTile/CheckboxTile.dart';
import 'package:muter/commons/widgets/CustomSlider/CustomSlider.dart';
import 'package:muter/commons/widgets/GroupList/GroupList.dart';
import 'package:muter/commons/widgets/Header/Header.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class SetAlarm extends StatefulWidget {
  @override
  _SetAlarmState createState() => _SetAlarmState();
}

class SetAlarmArguments {
  final int id;
  final String name;
  final bool isTransition;
  final double latitude;
  final double longitude;

  SetAlarmArguments({
    this.id,
    this.name,
    this.isTransition,
    this.latitude,
    this.longitude,
  });
}

class _SetAlarmState extends State<SetAlarm> {
  CurrentDistanceModel currentDistanceModel;
  TextEditingController newDistanceController;

  @override
  void initState() {
    super.initState();
    newDistanceController = TextEditingController(text: 0.toString());
    currentDistanceModel = CurrentDistanceModel.createInstance();

    // Setup vibration setting
    VibrationSetting.open().then((_) {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final SetAlarmArguments args = ModalRoute.of(context).settings.arguments;
      currentDistanceModel.name = args.name;
      currentDistanceModel.setCoord(args.latitude, args.longitude);

      NavigatorState navigatorState = Navigator.of(context);
      ActiveStationNotification.addListener(() {
        if (ActiveStationNotification.activeDistanceList.isEmpty) {
          navigatorState.pushNamedAndRemoveUntil('/Home', (_) => false);
        }
      });
    });
  }

  void setNewDistance(BuildContext context, int distance) {
    NewDistanceModel model = Provider.of(context, listen: false);
    model.newDistance = distance;
    newDistanceController.text = model.newDistance.toString();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final SetAlarmArguments args = ModalRoute.of(context).settings.arguments;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentDistanceModel>(
          create: (BuildContext context) => this.currentDistanceModel,
        ),
        ChangeNotifierProvider<DistanceListModel>(
          create: (BuildContext context) => DistanceListModel(),
        ),
        ChangeNotifierProvider<NewDistanceModel>(
          create: (BuildContext context) => NewDistanceModel(distance: 0),
        ),
      ],
      child: Scaffold(
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
                child: Consumer<CurrentDistanceModel>(
                    builder: (_, CurrentDistanceModel model, __) {
                  return Text(
                    model.name,
                    style: TextStyle(
                      color: AppColor.blue(1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
              ),
              Consumer<CurrentDistanceModel>(
                  builder: (_, CurrentDistanceModel model, __) {
                return Visibility(
                  visible: model.currentDistance != null,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.blue(1),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Text(
                      "${model.currentDistance.toString()} m",
                      style: TextStyle(
                        color: AppColor.white(1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/arts/line-wave.svg',
                    width: screenWidth * 0.35,
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
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        alignment: Alignment.centerLeft,
                        child: ActiveStationNotification.isActive()
                            ? NotificationInformation()
                            : ListView(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  left: 16,
                                  right: 16,
                                ),
                                children: [
                                  GroupList(
                                    firstLimit: null,
                                    title: tr("notif_vibrationsetting_title"),
                                    list: [
                                      VibrationSetting.hasAmplitudeControl ==
                                              true
                                          ? <Widget>[VibrationAmplitudeSlider()]
                                          : <Widget>[],
                                      <Widget>[
                                        VibrationDurationSlider(),
                                        VibrationRepeatSlider(),
                                        VibrationDelaySlider(),
                                      ],
                                    ].fold(<Widget>[],
                                        (List<Widget> list, List<Widget> temp) {
                                      list.addAll(temp);
                                      return list;
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 24,
                                    ),
                                  ),
                                  Consumer<DistanceListModel>(
                                    builder: (BuildContext context,
                                        DistanceListModel model, _) {
                                      return GroupList(
                                        title: tr(
                                            "notif_availabledistances_title"),
                                        firstLimit: null,
                                        list: <Widget>[
                                          ...model.checkedDistances
                                              .asMap()
                                              .map((int index,
                                                  Map<String, dynamic>
                                                      distanceData) {
                                                return MapEntry(
                                                    index,
                                                    CheckboxTile(
                                                      title: Text(
                                                        "${distanceData['distance']} m",
                                                        style: TextStyle(
                                                          color:
                                                              AppColor.black(1),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      value: distanceData[
                                                          'isChecked'],
                                                      onChanged:
                                                          (bool isChecked) {
                                                        model.updateDistance(
                                                          context,
                                                          index,
                                                          distanceData[
                                                              'distance'],
                                                          isChecked,
                                                        );
                                                      },
                                                    ));
                                              })
                                              .values
                                              .toList(),
                                          Consumer<CurrentDistanceModel>(
                                              builder: (_,
                                                  CurrentDistanceModel
                                                      currentDistanceModel,
                                                  __) {
                                            return Consumer<NewDistanceModel>(
                                                builder: (BuildContext context,
                                                    NewDistanceModel model,
                                                    __) {
                                              if (currentDistanceModel
                                                          .currentDistance !=
                                                      null &&
                                                  model.newDistance >
                                                      currentDistanceModel
                                                          .currentDistance) {
                                                setNewDistance(
                                                    context,
                                                    currentDistanceModel
                                                        .currentDistance);
                                              }

                                              return Column(
                                                children: [
                                                  CheckboxTile(
                                                    title: Row(
                                                      children: [
                                                        IntrinsicWidth(
                                                          child: TextField(
                                                            controller:
                                                                newDistanceController,
                                                            decoration: null,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .black(1),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            onSubmitted:
                                                                (String value) {
                                                              int newValue =
                                                                  int.parse(
                                                                      value);

                                                              if (newValue <=
                                                                      0 ||
                                                                  newValue >=
                                                                      currentDistanceModel
                                                                          .currentDistance) {
                                                                Scaffold.of(
                                                                    context)
                                                                  ..removeCurrentSnackBar()
                                                                  ..showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        sprintf(
                                                                          tr("notif_distanceconstraint_alert"),
                                                                          [
                                                                            newValue,
                                                                            currentDistanceModel.currentDistance
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                newDistanceController
                                                                        .text =
                                                                    0.toString();
                                                                return;
                                                              }

                                                              newDistanceController
                                                                      .text =
                                                                  newValue
                                                                      .toString();
                                                              model.newDistance =
                                                                  newValue;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 8,
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColor
                                                                .grayLight(1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 4,
                                                            horizontal: 12,
                                                          ),
                                                          child: Text(
                                                            'm',
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .black(1),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: false,
                                                    onChanged:
                                                        (bool isChecked) {
                                                      Provider.of<
                                                          DistanceListModel>(
                                                        context,
                                                        listen: false,
                                                      ).addDistance(
                                                        context,
                                                        model.newDistance,
                                                        isChecked,
                                                      );
                                                    },
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 24,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: CustomSlider(
                                                          disabled:
                                                              currentDistanceModel
                                                                      .currentDistance ==
                                                                  null,
                                                          value: model
                                                              .newDistance
                                                              .toDouble(),
                                                          min: 0.0,
                                                          max: currentDistanceModel
                                                                      .currentDistance ==
                                                                  null
                                                              ? 0.0
                                                              : currentDistanceModel
                                                                  .currentDistance
                                                                  .toDouble(),
                                                          onChanged:
                                                              (double value) {
                                                            setNewDistance(
                                                                context,
                                                                value.toInt());
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                          }),
                                        ],
                                      );
                                    },
                                  ),
                                  Container(
                                    height: 250,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: IntrinsicHeight(
                        child: Container(
                          width: screenWidth,
                          padding: const EdgeInsets.only(
                            bottom: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Visibility(
                                  visible: ActiveStationNotification.isActive(),
                                  child: Button(
                                    label: tr("notif_button_cancel"),
                                    type: ButtonType.outline,
                                    onTap: () {
                                      ActiveStationNotification.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  replacement: Button(
                                    label: tr("notif_button_done"),
                                    type: ButtonType.filled,
                                    onTap: () async {
                                      DistanceListModel distanceListModel =
                                          Provider.of<DistanceListModel>(
                                        context,
                                        listen: false,
                                      );

                                      List<int> distanceList = distanceListModel
                                          .distanceList
                                          .toList();

                                      if (distanceList.isEmpty) {
                                        Scaffold.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                tr("notif_pickoneatleast_alert"),
                                              ),
                                            ),
                                          );
                                        return;
                                      }

                                      ActiveStationNotification.set(
                                        context: context,
                                        stationId: args.id,
                                        distanceList: distanceList,
                                      );

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // GroupList(
              //   title: 'Vibration Level',
              //   list: <Widget>[Text("Hahah")],
              // ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    currentDistanceModel.stopListen();
    super.dispose();
  }
}

class VibrationAmplitudeSlider extends StatefulWidget {
  const VibrationAmplitudeSlider({
    Key key,
  }) : super(key: key);

  @override
  _VibrationAmplitudeSliderState createState() =>
      _VibrationAmplitudeSliderState();
}

class _VibrationAmplitudeSliderState extends State<VibrationAmplitudeSlider> {
  @override
  Widget build(BuildContext context) {
    int amplitude = VibrationSetting.amplitude;
    return LabeledCustomSlider(
      min: VibrationSetting.MIN_AMPLITUDE.toDouble(),
      max: VibrationSetting.MAX_AMPLITUDE.toDouble(),
      label: tr("notif_amplitude_label"),
      showValue: (double value) {
        return VibrationSetting.categorizeAmplitude().toString();
      },
      value: amplitude.toDouble(),
      onChanged: (double value) {
        setState(
          () {
            VibrationSetting.amplitude = value.toInt();
          },
        );
      },
    );
  }
}

class VibrationDurationSlider extends StatefulWidget {
  const VibrationDurationSlider({
    Key key,
  }) : super(key: key);

  @override
  _VibrationDurationSliderState createState() =>
      _VibrationDurationSliderState();
}

class _VibrationDurationSliderState extends State<VibrationDurationSlider> {
  @override
  Widget build(BuildContext context) {
    int duration = VibrationSetting.duration;
    return LabeledCustomSlider(
      min: VibrationSetting.MIN_DURATION.toDouble(),
      max: VibrationSetting.MAX_DURATION.toDouble(),
      label: "${tr("notif_duration_label")}",
      value: duration.toDouble(),
      showValue: (double value) {
        return "${(value / 1000).toStringAsFixed(1)} ${tr("common_time_second").toLowerCase()}";
      },
      onChanged: (double value) {
        setState(() {
          VibrationSetting.duration = value.toInt();
        });
      },
    );
  }
}

class VibrationRepeatSlider extends StatefulWidget {
  @override
  _VibrationRepeatSliderState createState() => _VibrationRepeatSliderState();
}

class _VibrationRepeatSliderState extends State<VibrationRepeatSlider> {
  @override
  Widget build(BuildContext context) {
    int repeatCount = VibrationSetting.repeatCount;
    return LabeledCustomSlider(
      min: VibrationSetting.MIN_REPEAT_COUNT.toDouble(),
      max: VibrationSetting.MAX_REPEAT_COUNT.toDouble(),
      label: "${tr("notif_repetition_label")}",
      showValue: (double value) {
        return repeatCount.toString();
      },
      value: repeatCount.toDouble(),
      onChanged: (double value) {
        setState(
          () {
            VibrationSetting.repeatCount = value.toInt();
          },
        );
      },
    );
  }
}

class VibrationDelaySlider extends StatefulWidget {
  @override
  _VibrationDelaySliderState createState() => _VibrationDelaySliderState();
}

class _VibrationDelaySliderState extends State<VibrationDelaySlider> {
  @override
  Widget build(BuildContext context) {
    int repeatDelay = VibrationSetting.repeatDelay;
    return LabeledCustomSlider(
      min: VibrationSetting.MIN_REPEAT_DELAY.toDouble(),
      max: VibrationSetting.MAX_REPEAT_DELAY.toDouble(),
      label: "${tr("notif_repeatdelay_label")}",
      value: repeatDelay.toDouble(),
      showValue: (double value) {
        return "${(value / 1000).toStringAsFixed(1)} ${tr("common_time_second").toLowerCase()}";
      },
      onChanged: (double value) {
        setState(
          () {
            VibrationSetting.repeatDelay = value.toInt();
          },
        );
      },
    );
  }
}

typedef ShowValue = String Function(double value);

class LabeledCustomSlider extends StatelessWidget {
  final String iconUrl;
  final String label;
  final int divisions;
  final bool disabled;
  final ShowValue showValue;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  LabeledCustomSlider({
    Key key,
    this.iconUrl = "assets/icons/swipe.svg",
    @required this.label,
    @required this.value,
    this.showValue,
    @required this.onChanged,
    @required this.min,
    @required this.max,
    this.divisions,
    this.disabled = false,
  }) : super(key: key) {
    // Icon url must refer to SVG file
    assert(this.iconUrl.split(".").last == "svg");
  }

  @override
  Widget build(BuildContext context) {
    ShowValue showValue = this.showValue ?? (double value) => value.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimplePair(
          label: label,
          value: showValue(value),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 16,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconUrl,
              height: 24,
              color: AppColor.blue(1),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 24,
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomSlider(
                value: value,
                disabled: disabled,
                divisions: divisions,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NotificationInformation extends StatefulWidget {
  const NotificationInformation({
    Key key,
  }) : super(key: key);

  @override
  _NotificationInformationState createState() =>
      _NotificationInformationState();
}

class _NotificationInformationState extends State<NotificationInformation> {
  List<int> originalDistanceList = <int>[];
  List<int> activeDistanceList = <int>[];

  @override
  void initState() {
    super.initState();
    setDistances();
    ActiveStationNotification.addListener(() {
      if (mounted) setState(setDistances);
    });
  }

  void setDistances() {
    originalDistanceList = ActiveStationNotification.originalDistanceList;
    activeDistanceList = ActiveStationNotification.activeDistanceList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      children: <Widget>[
        GroupList(
          firstLimit: null,
          title: tr("notif_vibrationsetting_title"),
          list: [
            VibrationSetting.hasAmplitudeControl == true
                ? <Widget>[
                    SimplePair(
                      label: tr("notif_amplitude_label"),
                      value: "${VibrationSetting.categorizeAmplitude()}",
                    ),
                  ]
                : <Widget>[],
            <Widget>[
              SimplePair(
                label: tr("notif_duration_label"),
                value:
                    "${(VibrationSetting.duration / 1000).toStringAsFixed(1)} ${tr("common_time_second").toLowerCase()}",
              ),
              SimplePair(
                label: tr("notif_repetition_label"),
                value: "${VibrationSetting.repeatCount}",
              ),
              SimplePair(
                label: tr("notif_repeatdelay_label"),
                value:
                    "${(VibrationSetting.repeatDelay / 1000).toStringAsFixed(1)} ${tr("common_time_second").toLowerCase()}",
              ),
            ],
          ].fold(<Widget>[], (List<Widget> allWidgets, List<Widget> widgets) {
            allWidgets.addAll(widgets);
            return allWidgets;
          }),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 24,
          ),
        ),
        GroupList(
          firstLimit: null,
          title: tr("notif_selecteddistancelist_title"),
          list: originalDistanceList
              .asMap()
              .map((int index, int distance) {
                return MapEntry(
                  index,
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$distance m",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: index < activeDistanceList.length
                            ? AppColor.black(1)
                            : AppColor.gray(1),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList()
              .reversed
              .toList(),
        )
      ],
    );
  }
}

class SimplePair extends StatelessWidget {
  final String label;
  final String value;

  const SimplePair({
    Key key,
    @required this.label,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColor.black(1),
            fontSize: 14,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColor.black(1),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: AppColor.white(1),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
