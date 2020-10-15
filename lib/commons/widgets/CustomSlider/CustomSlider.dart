import 'package:flutter/material.dart';
import 'package:muter/commons/helper/helper.dart';

class CustomSlider extends StatelessWidget {
  final int divisions;
  final bool disabled;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    this.disabled = false,
    this.divisions,
    @required this.value,
    @required this.onChanged,
    @required this.min,
    @required this.max,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(disabledThumbRadius: 3.0),
        trackShape: CustomTrackShape(),
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.redAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Slider(
        label: '${this.value}',
        activeColor: this.disabled ? AppColor.grayLight(1) : AppColor.blue(1),
        value: this.value,
        onChanged: onChanged,
        divisions: this.divisions,
        min: this.min,
        max: this.max,
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
