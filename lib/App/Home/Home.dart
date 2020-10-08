import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/App/Home/widgets/SignLanguage/SignLanguage.dart';

import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Header/Header.dart';
import 'package:muter/App/Home/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './widgets/Chat/Chat.dart';
import './widgets/TrainNotification/TrainNotification.dart';
import './widgets/SignLanguage/SignLanguage.dart';

class Home extends StatelessWidget {
  final Map pages = <int, Widget>{
    0: SignLanguage(),
    1: TrainNotification(),
    2: Chat(),
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (BuildContext context) => HomeModel(currentPageIndex: 0),
      child: Scaffold(
        appBar: Header(
          content: Row(
            children: [
              Expanded(flex: 1, child: SizedBox.shrink()),
              Name(),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<HomeModel>(builder: (_, HomeModel model, __) {
                    return this.pages[model.currentPageIndex];
                  }),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: FloatingFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Name extends StatefulWidget {
  Name({
    Key key,
  }) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  SharedPreferences prefs;
  TextEditingController nameController;
  AvatarIcon icon;

  static const String NAME_KEY = "NAME";
  static const String ICON_NAME = "ICON";

  static const List<Map<String, dynamic>> ACCOUNT_LIST = [
    {
      NAME_KEY: "Confident Koala",
      ICON_NAME: AvatarIcon.koala,
    },
    {
      NAME_KEY: "Lovable Parrot",
      ICON_NAME: AvatarIcon.parrot,
    },
    {
      NAME_KEY: "Fabulous Rabbit",
      ICON_NAME: AvatarIcon.rabbit,
    },
    {
      NAME_KEY: "Overpowered Snail",
      ICON_NAME: AvatarIcon.snail,
    },
    {
      NAME_KEY: "Amazing Frog",
      ICON_NAME: AvatarIcon.frog,
    },
  ];

  @override
  void initState() {
    super.initState();
    setAccountFromPreferences();
  }

  void setAccountFromPreferences() async {
    this.prefs = await SharedPreferences.getInstance();
    String name = this.prefs.getString(NAME_KEY);
    AvatarIcon icon = AvatarIcon.getIconByName(prefs.getString(ICON_NAME));

    if (name == null) {
      Random random = Random();
      Map<String, dynamic> account =
          ACCOUNT_LIST[random.nextInt(ACCOUNT_LIST.length)];

      name = account[NAME_KEY];
      icon = account[ICON_NAME];

      await this.prefs.setString(NAME_KEY, name);
      await this.prefs.setString(ICON_NAME, icon.name);
    }

    setAccount(name: name, icon: icon);
  }

  void setAccount({
    String name,
    AvatarIcon icon,
  }) {
    Account.name = name ?? Account.name;
    Account.icon = icon ?? Account.icon;

    setState(() {
      this.nameController = TextEditingController(text: Account.name);
      this.icon = Account.icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/pencil.svg',
          color: AppColor.blue(1),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8,
          ),
        ),
        IntrinsicWidth(
          child: TextField(
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColor.black(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                hintText: tr("home_name_hint"),
              ),
              controller: this.nameController,
              onSubmitted: (String newName) {
                setAccount(name: newName);
              },
              style: TextStyle(
                  fontSize: 16,
                  color: AppColor.blue(1),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ]),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 16,
          ),
        ),
        icon == null
            ? SizedBox.shrink()
            : Avatar(
                icon: icon,
              )
      ],
    );
  }

  @override
  void dispose() {
    this.nameController.dispose();
    super.dispose();
  }
}

typedef PageOnUpdate = void Function(int index);

class FloatingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = 60;
    double homeIconRadius = 30;

    return Container(
      color: Colors.transparent,
      width: width,
      height: height + homeIconRadius,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: AppColor.white(1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200),
                  ),
                  boxShadow: [
                    AppShadow.hardShadow,
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: FeatureIcon(
                          iconPath: 'assets/icons/alarm.svg',
                          name: tr('bottombar_notif_name'),
                          onTap: () {
                            HomeModel model =
                                Provider.of<HomeModel>(context, listen: false);
                            model.currentPageIndex = 1;
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 2 * homeIconRadius,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: FeatureIcon(
                          iconPath: 'assets/icons/chat.svg',
                          name: tr('bottombar_chat_name'),
                          onTap: () {
                            HomeModel model =
                                Provider.of<HomeModel>(context, listen: false);
                            model.currentPageIndex = 2;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {
                  HomeModel model =
                      Provider.of<HomeModel>(context, listen: false);
                  model.currentPageIndex = 0;
                },
                child: Container(
                  height: 2 * homeIconRadius,
                  width: 2 * homeIconRadius,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.grayLight(1),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/icons/logo.svg",
                    height: 2 * homeIconRadius * 0.65,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeatureIcon extends StatelessWidget {
  final String iconPath;
  final String name;
  final VoidCallback onTap;

  const FeatureIcon({
    Key key,
    @required this.iconPath,
    @required this.name,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              this.iconPath,
              height: 24,
            ),
            Text(
              this.name,
              style: TextStyle(
                color: AppColor.black(1),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
