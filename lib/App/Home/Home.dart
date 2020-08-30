import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/App/Home/widgets/SignLanguage/SignLanguage.dart';

import 'package:muter/commons/Avatar/Avatar.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/models/HomeModel.dart';
import 'package:provider/provider.dart';
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
        appBar: Header(),
        body: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<HomeModel>(
                          builder: (_, HomeModel model, __) {
                        return this.pages[model.currentPageIndex];
                      }),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Footer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget implements PreferredSize {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double pagePaddingVertical = 24;
    double pagePaddingHorizontal = 16;
    return Container(
      padding: EdgeInsets.only(
          top: statusBarHeight + pagePaddingVertical,
          left: pagePaddingHorizontal,
          right: pagePaddingHorizontal,
          bottom: pagePaddingVertical),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: Navigator.of(context).canPop(),
            child: InkWell(
              onTap: () => {
                if (Navigator.of(context).canPop())
                  {Navigator.of(context).pop(context)}
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                height: 18,
              ),
            ),
          ),
          Expanded(flex: 1, child: SizedBox.shrink()),
          Name(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(double.maxFinite);

  @override
  Widget get child => throw UnimplementedError();
}

class Name extends StatefulWidget {
  Name({
    Key key,
  }) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    this.nameController = TextEditingController(text: "Confident Koala");
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
            decoration: null,
            controller: this.nameController,
            onChanged: (String value) => {print(value)},
            style: TextStyle(
                fontSize: 16,
                color: AppColor.blue(1),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 16,
          ),
        ),
        Avatar(
          icon: AvatarIcon.koala,
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

class Footer extends StatelessWidget {
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
                          name: 'Alarm me!',
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
                          name: 'Chat',
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
