import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:path/path.dart' as p;

class AvatarIcon {
  static String iconBasePath = 'assets/avatars/';

  static const AvatarIcon koala = AvatarIcon(name: 'koala.svg');
  static const AvatarIcon parrot = AvatarIcon(name: 'parrot.svg');
  static const AvatarIcon rabbit = AvatarIcon(name: 'rabbit.svg');
  static const AvatarIcon snail = AvatarIcon(name: 'snail.svg');
  static const AvatarIcon frog = AvatarIcon(name: 'frog.svg');

  static const AvatarIcon normalStation =
      AvatarIcon(name: 'normal-station.svg');
  static const AvatarIcon transitionStation =
      AvatarIcon(name: 'transition-station.svg');

  final String name;

  const AvatarIcon({
    @required this.name,
  });

  static String getAssetPath(AvatarIcon icon) {
    return p.join(iconBasePath, icon.name);
  }
}

class Avatar extends StatelessWidget {
  final bool editable;
  final double radius;
  final AvatarIcon icon;

  Avatar(
      {Key key, this.editable = false, this.radius = 38, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.radius,
      width: this.radius,
      decoration: BoxDecoration(
        color: AppColor.grayLight(1),
        borderRadius: BorderRadius.circular(200),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        AvatarIcon.getAssetPath(this.icon),
        height: this.radius * 0.5,
      ),
    );
  }
}
