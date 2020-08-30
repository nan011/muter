import 'package:flutter/material.dart';

typedef ColorSetter = Color Function(double opacity);

class AppColor {
  static ColorSetter black = Utility.getColorSetter("#535353");
  static ColorSetter white = Utility.getColorSetter("#FFFFFF");
  static ColorSetter blue = Utility.getColorSetter("#134B66");
  static ColorSetter red = Utility.getColorSetter("#E60B64");
  static ColorSetter grayLight = Utility.getColorSetter("#EDEDED");
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
