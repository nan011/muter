import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';

class GroupList extends StatefulWidget {
  final String title;
  final int firstLimit;
  final List<Widget> list;
  final double gap;
  final Widget emptyReplacement;

  GroupList({
    Key key,
    @required this.title,
    this.emptyReplacement,
    this.firstLimit = 3,
    this.list = const <Widget>[],
    this.gap = 8,
  }) : super(key: key) {
    assert(firstLimit == null || firstLimit > 0);
  }

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  bool useFirstLimit;
  int shownTotal;

  void _setup() {
    useFirstLimit =
        widget.firstLimit != null && widget.firstLimit < widget.list.length;
    shownTotal = useFirstLimit ? widget.firstLimit : widget.list.length;
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  bool isShowingAll() {
    return shownTotal == widget.list.length;
  }

  void swapShownTotal() {
    if (widget.firstLimit == null) return;

    setState(() {
      if (isShowingAll()) {
        shownTotal = widget.firstLimit;
      } else {
        shownTotal = widget.list.length;
      }
    });
  }

  @override
  void didUpdateWidget(GroupList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    String moreLabel = tr("grouplist_more_label");
    if (moreLabel == "grouplist_more_label") moreLabel = "More...";

    String lessLabel = tr("grouplist_less_label");
    if (lessLabel == "grouplist_less_label") lessLabel = "Less...";

    Widget emptyReplacement = widget.emptyReplacement ??
        () {
          String emptyLabel = tr("grouplist_empty");
          if (emptyLabel == "grouplist_empty") emptyLabel = "List is empty";

          return Text(
            emptyLabel,
            style: TextStyle(
              color: AppColor.gray(1),
              fontSize: 14,
            ),
          );
        }();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
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
          ),
          // Body
          Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 8,
            ),
            child: this.widget.list.length == 0
                ? Container(
                    alignment: Alignment.centerLeft,
                    child: emptyReplacement,
                  )
                : Column(
                    children: this
                        .widget
                        .list
                        .sublist(0, shownTotal)
                        .fold(<Widget>[], (newList, widget) {
                      return <Widget>[
                        ...newList,
                        widget,
                        Padding(
                          padding: EdgeInsets.only(
                            top: this.widget.gap,
                          ),
                        ),
                      ];
                    })
                          ..removeLast()
                          ..add(
                            Visibility(
                              visible: useFirstLimit,
                              child: InkWell(
                                onTap: () {
                                  swapShownTotal();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    isShowingAll() ? lessLabel : moreLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.black(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
          )
        ],
      ),
    );
  }
}
