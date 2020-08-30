import 'package:flutter/material.dart';
import 'package:muter/commons/DefaultFrame/DefaultFrame.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultFrame(
      child: Container(
        height: 200,
        width: 100,
        color: Colors.redAccent,
      ),
    );
  }
}
