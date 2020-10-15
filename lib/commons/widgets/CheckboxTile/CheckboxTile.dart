import 'package:flutter/material.dart';
import 'package:muter/commons/helper/helper.dart';

typedef CheckboxOnChange = void Function(bool isChecked);

class CheckboxTile extends StatefulWidget {
  final CheckboxOnChange onChanged;
  final bool value;
  final Widget title;

  CheckboxTile({
    Key key,
    this.title,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _CheckboxTileState createState() => _CheckboxTileState();
}

class _CheckboxTileState extends State<CheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                height: 17,
                width: 17,
                child: Checkbox(
                  value: widget.value,
                  onChanged: null,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColor.blue(1),
                  checkColor: AppColor.white(1),
                  tristate: false,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8,
              ),
            ),
            Expanded(
              flex: 1,
              child: widget.title,
            ),
          ],
        ),
      ),
    );
  }
}
