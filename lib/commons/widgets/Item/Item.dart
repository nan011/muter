import 'package:flutter/material.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';

class Item extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final AvatarIcon icon;

  Item({
    Key key,
    this.icon = AvatarIcon.rabbit,
    @required this.name,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(
              icon: this.icon,
              radius: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Expanded(
              flex: 1,
              child: Text(
                this.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColor.black(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
