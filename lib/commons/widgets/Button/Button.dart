import 'package:flutter/material.dart';
import 'package:muter/commons/helper/helper.dart';

enum ButtonType {
  filled,
  outline,
}

class Button extends StatelessWidget {
  final String label;
  final ButtonType type;
  final bool clickable;
  final VoidCallback onTap;

  Button({
    Key key,
    @required this.label,
    this.type = ButtonType.filled,
    this.clickable = true,
    this.onTap,
  }) : super(key: key);

  Color selectTextColor(ButtonType type) {
    switch (type) {
      case ButtonType.filled:
        return AppColor.white(1);
      case ButtonType.outline:
        return AppColor.black(1);
      default:
        return selectTextColor(ButtonType.filled);
    }
  }

  Color selectBackgroundColor(ButtonType type) {
    switch (type) {
      case ButtonType.filled:
        return AppColor.blue(1);
      case ButtonType.outline:
        return Colors.transparent;
      default:
        return selectTextColor(ButtonType.filled);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        this.clickable ? selectTextColor(this.type) : AppColor.white(1);
    Color backgroundColor = this.clickable
        ? selectBackgroundColor(this.type)
        : AppColor.grayLight(1);
    return InkWell(
      onTap: this.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: this.clickable && this.type == ButtonType.outline
              ? Border.all(
                  color: AppColor.red(1),
                )
              : null,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Text(
          this.label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
