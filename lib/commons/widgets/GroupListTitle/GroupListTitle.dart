import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';

class GroupListTitle extends StatelessWidget {
  const GroupListTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: AppColor.black(1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4,
          ),
        ),
        SvgPicture.asset(
          'assets/arts/title-bar.svg',
          height: 2,
        )
      ],
    );
  }
}
