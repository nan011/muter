import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';

typedef OnSubmit = void Function(String value);

class SearchBar extends StatefulWidget {
  final OnSubmit onSubmit;
  final String hint;
  final bool inRealTime;

  SearchBar({
    Key key,
    this.onSubmit,
    this.hint,
    this.inRealTime = false,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: "");
  }

  void setValue(String value) {
    setState(() {
      this.searchController.text = value;
    });
    sendValue();
  }

  void sendValue() {
    widget.onSubmit(this.searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.grayLight(1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColor.black(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        hintText: widget.hint,
                      ),
                      controller: this.searchController,
                      style: TextStyle(
                        color: AppColor.black(1),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        if (widget.inRealTime) {
                          widget.onSubmit(value);
                        }
                      },
                      onSubmitted: (String value) {
                        setValue(value);
                      },
                      maxLines: 1,
                    ),
                  ),
                  Visibility(
                    visible: searchController.text.isNotEmpty,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              searchController.text = "";
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/icons/close.svg',
                            color: AppColor.black(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8,
            ),
          ),
          InkWell(
            onTap: () {
              sendValue();
            },
            child: SvgPicture.asset(
              'assets/icons/magnifier.svg',
            ),
          ),
        ],
      ),
    );
  }
}
