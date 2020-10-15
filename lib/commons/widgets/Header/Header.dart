import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSize {
  final Widget content;

  Header({
    Key key,
    this.content,
  }) : super(key: key);

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
          Expanded(
            child: this.content,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(double.maxFinite);

  @override
  Widget get child => throw UnimplementedError();
}
