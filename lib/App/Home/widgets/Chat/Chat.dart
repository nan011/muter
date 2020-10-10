import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:muter/App/GroupChat/GroupChat.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:muter/commons/widgets/Avatar/Avatar.dart';
import 'package:muter/commons/widgets/GroupList/GroupList.dart';
import 'package:muter/commons/widgets/GroupListTitle/GroupListTitle.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map<String, dynamic>> groupChats = [
  {
    'pair': ['Rangkas Bitung', 'Tanah Abang'],
  },
  {
    'pair': ['Tanah Abang', 'Duri'],
  },
  {
    'pair': ['Tanah Abang', 'Tangerang'],
  },
  {
    'pair': ['Duri', 'Kampung Bandan'],
  },
  {
    'pair': ['Kampung Bandan', 'Jatinegara'],
  },
  {
    'pair': ['Cikarang', 'Jatinegara'],
  },
  {
    'pair': ['Jatinegara', 'Manggarai'],
  },
  {
    'pair': ['Manggarai', 'Jakarta Kota'],
  },
  {
    'pair': ['Bogor', 'Citayam'],
  },
  {
    'pair': ['Nambo', 'Citayam'],
  },
  {
    'pair': ['Citayam', 'Manggarai'],
  },
  {
    'pair': ['Manggarai', 'Tanah Abang'],
  },
].map((Map<String, dynamic> groupChat) {
  String firstStation =
      ((groupChat['pair'] as List<String>)[0]).replaceAll(" ", "");
  String secondStation =
      ((groupChat['pair'] as List<String>)[1]).replaceAll(" ", "");
  return {
    ...groupChat,
    'id': "${firstStation}_$secondStation",
  };
}).toList();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Widget> rawNewsList;
  List<Widget> newsList;
  String newsListNextToken;
  bool shouldStopFetchNews;
  RefreshController newsRefreshController;

  @override
  void initState() {
    super.initState();
    rawNewsList = [];
    newsList = setListWithGap(
      List.generate(
        10,
        (_) => ContentPlaceholder(
          width: 200,
          height: 120,
        ),
      ),
      8.0,
      Axis.horizontal,
    );
    shouldStopFetchNews = false;
    newsRefreshController = RefreshController();
    loadNews();
  }

  @override
  void dispose() {
    newsRefreshController.dispose();
    super.dispose();
  }

  List<Widget> setListWithGap(
    List<Widget> list,
    double gap,
    Axis axis,
  ) {
    if (list.length == 0) return [];

    return list.fold(<Widget>[], (List<Widget> newList, Widget widget) {
      return [
        ...newList,
        widget,
        Padding(
          padding: EdgeInsets.only(
            top: axis == Axis.vertical ? gap : 0.0,
            left: axis == Axis.horizontal ? gap : 0.0,
          ),
        ),
      ];
    })
      ..removeLast();
  }

  Future loadNews() async {
    if (shouldStopFetchNews) return;

    final token =
        "AAAAAAAAAAAAAAAAAAAAAO3xIQEAAAAAn2idv1Va8paBLl1FJ3QJ6CY2GjA%3Du5XwKY9ItlXiC1GDpli2vSFSmNIWlaVvxW44r4YdL8yYDZIBKD";
    String url =
        "https://api.twitter.com/2/tweets/search/recent?query=%23RekanCommuters&tweet.fields=created_at";
    url =
        newsListNextToken != null ? "$url&next_token=$newsListNextToken" : url;

    var response = await http.Client().get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    var body = json.decode(response.body);

    if (response.statusCode != 200) return;

    List<Widget> rawNewsList = (body['data'] as List).map((dynamic tweet) {
      DateTime createdAt = DateTime.parse(tweet['created_at']).toLocal();
      if (createdAt.day < DateTime.now().day) {
        shouldStopFetchNews = true;
      }
      return News(
        url: "https://twitter.com/CommuterLine/status/${tweet['id']}",
        title: (tweet['text'] as String)
            .replaceAll('#RekanCommuters ', '')
            .replaceAll('RT @CommuterLine: ', ''),
        time: createdAt,
      );
    }).toList();

    if (newsListNextToken != null) {
      this.rawNewsList.addAll(rawNewsList);
    } else {
      this.rawNewsList = rawNewsList;
    }

    newsListNextToken = body['meta']['next_token'];
    setState(() {
      this.newsList = setListWithGap(this.rawNewsList, 8.0, Axis.horizontal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      alignment: Alignment.center,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: 300,
        ),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: GroupListTitle(
                  title: tr('chat_news_title'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
              ),
              SizedBox(
                width: width,
                height: 120,
                child: SmartRefresher(
                  controller: newsRefreshController,
                  enablePullDown: false,
                  enablePullUp: !shouldStopFetchNews,
                  scrollDirection: Axis.horizontal,
                  onLoading: () async {
                    await loadNews();
                    newsRefreshController.loadComplete();
                  },
                  onRefresh: () => newsRefreshController.refreshCompleted(),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    itemCount: newsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return newsList[index];
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: GroupList(
              title: tr('chat_livechat_title'),
              firstLimit: null,
              list: groupChats.map((Map<String, dynamic> groupChat) {
                return StationPairItem(
                  firstStationName: groupChat['pair'][0],
                  secondStationName: groupChat['pair'][1],
                  onTap: () {
                    GroupChatArguments args = GroupChatArguments(
                      id: groupChat["id"],
                      firstStationName: groupChat['pair'][0],
                      secondStationName: groupChat['pair'][1],
                    );
                    Navigator.of(context).pushNamed(
                      "/GroupChat",
                      arguments: args,
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class StationPairItem extends StatelessWidget {
  final VoidCallback onTap;
  final String firstStationName;
  final String secondStationName;

  StationPairItem({
    Key key,
    @required this.firstStationName,
    @required this.secondStationName,
    this.onTap,
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
              icon: AvatarIcon.transitionStation,
              radius: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularBar(
                    label: firstStationName,
                    backgroundColor: AppColor.blue(1),
                    textColor: AppColor.white(1),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: SvgPicture.asset(
                        "assets/arts/station-connector.svg",
                        height: 6,
                      )),
                  CircularBar(
                    label: secondStationName,
                    backgroundColor: AppColor.red(1),
                    textColor: AppColor.white(1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularBar extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String label;

  CircularBar({
    Key key,
    @required this.backgroundColor,
    @required this.textColor,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Text(
        this.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class News extends StatelessWidget {
  static const String KRL_IN_MORNING_IMAGE_URL =
      "assets/wallpapers/krl-in-morning.jpg";
  static const String KRL_IN_DAY_IMAGE_URL = "assets/wallpapers/krl-in-day.jpg";
  static const String KRL_IN_AFTERNOON_IMAGE_URL =
      "assets/wallpapers/krl-in-afternoon.jpeg";
  static const String KRL_IN_NIGHT_IMAGE_URL =
      "assets/wallpapers/krl-in-night.jpg";

  final String url;
  final String backgroundUrl;
  final String title;
  final DateTime time;

  News({
    Key key,
    @required this.url,
    this.backgroundUrl,
    @required this.title,
    @required this.time,
  }) : super(key: key);

  String getImageUrlBasedOnTime() {
    final int hour = time.hour;
    if (hour <= 10) {
      return KRL_IN_MORNING_IMAGE_URL;
    } else if (hour <= 14) {
      return KRL_IN_DAY_IMAGE_URL;
    } else if (hour <= 18) {
      return KRL_IN_AFTERNOON_IMAGE_URL;
    } else {
      return KRL_IN_NIGHT_IMAGE_URL;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundUrl = this.backgroundUrl ?? getImageUrlBasedOnTime();
    final int currentDay = DateTime.now().day;

    return InkWell(
      onTap: () async {
        print(url);
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: 200,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundUrl.startsWith('http')
                    ? CachedNetworkImageProvider(backgroundUrl)
                    : AssetImage(backgroundUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double height = constraints.maxHeight;
                final double width = constraints.maxWidth;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: height,
                        width: width,
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/clock.svg',
                                  height: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 4,
                                  ),
                                ),
                                Text(
                                  "${currentDay > time.day ? "${time.day}/${time.month}/${time.year}" : ''} ${time.hour}:${time.minute}",
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
