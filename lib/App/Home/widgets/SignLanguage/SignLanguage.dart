import 'package:cached_network_image/cached_network_image.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';
import 'package:sprintf/sprintf.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum ContentViewType {
  cards,
  videos,
}

List<SignCardData> signCards = [
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1vmyUPpBg5QrHNCB2t76-dUHEcA3y7Re2",
    name: sprintf(tr("home_station_label"), [
      "Sawah Besar",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=13NxNHIoKnX3YVx3p9NQAAoXPuKRdGm2O",
    name: sprintf(tr("home_station_label"), [
      "Rawa Buaya",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=13-7WzBCDkJ-wFqGi4ftrZ5KjgT9PqI85",
    name: sprintf(tr("home_station_label"), [
      "Sudirman Baru",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1IAhI0qaZPsAQED4569oHGM_5VQHevPw5",
    name: sprintf(tr("home_station_label"), [
      "Tebet",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1MRM2khBhwHR3q42zYGRKg9oa23hb5fwi",
    name: sprintf(tr("home_station_label"), [
      "Pondok Cina",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1QQcu5URZpOUEAsMttZhAx79jNTbmMy5Q",
    name: sprintf(tr("home_station_label"), [
      "Mangga Besar",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1nHjvqdT1a2vq6WHdlMSRDbRQUQR4gebY",
    name: sprintf(
      tr("home_station_label"),
      ["Pasar Minggu Baru"],
    ),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=13rs-HenJuc6Kn4qUbGjEv2y3Glqr0dO5",
    name: sprintf(tr("home_station_label"), [
      "Pasar Minggu",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1AA2zJnbsYfrd0nfnWfA8NNR8mCvyz10s",
    name: sprintf(tr("home_station_label"), [
      "Lenteng Agung",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1pm0X8RsBhuaoNlmmAKgvd-c4kdS5ogJp",
    name: sprintf(tr("home_station_label"), [
      "Juanda",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1P9xusI7_H1r5U78l8bKrYwXU1Z-qE338",
    name: sprintf(tr("home_station_label"), [
      "Kalibata",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1Fv6BhZThwuPB49yMG14VbJwqsMJ0yRlj",
    name: sprintf(tr("home_station_label"), [
      "Jayakarta",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1lkxRAdkrtBKRMp8mW__l4OWiJEiJ7AZU",
    name: sprintf(tr("home_station_label"), [
      "Jakarta Kota",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1VVetAKpW2_MrDVzkOkzBshNLfFzHwheT",
    name: sprintf(tr("home_station_label"), [
      "Gondangdia",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1bVZ2PHU_VMilxLsqCdwejZO-fNzycAMQ",
    name: sprintf(tr("home_station_label"), [
      "Gambir",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1nTXS_J21HuCNsh4BO0ioiU7ewfIvqnI3",
    name: sprintf(tr("home_station_label"), [
      "Depok Baru",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1_i0BunzeTyDr5BbPKuOE6nMhjK5yoCln",
    name: sprintf(tr("home_station_label"), [
      "Citayam",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1kQQqWik_eMH1yZx7puQKhRvZyYOx9QEo",
    name: sprintf(tr("home_station_label"), [
      "Cilebut",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1P747_zfYdC-jMigH7mktbWdjpQuwPMII",
    name: sprintf(tr("home_station_label"), [
      "Cikini",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1C5smI3EObk7mNXw1E-iNv7CDZY5QOJ69",
    name: sprintf(tr("home_station_label"), [
      "Kemayoran",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1Vr1TjlBSEBEZfC6OWetiJJo_KzW6Mrf0",
    name: sprintf(tr("home_station_label"), [
      "Rajawali",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1zrlU22EqxwANzIrNi1qbBs1nZhBcckGA",
    name: sprintf(tr("home_station_label"), [
      "Jatinegara",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1pagDEG0GkZw680pSKW4GYSfcHsTlZ02J",
    name: sprintf(tr("home_station_label"), [
      "Cawang",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1Nm9SQhjne2JG8gDzhKdNuutZg9rvLAI8",
    name: sprintf(tr("home_station_label"), [
      "Pasar Senen",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1X8iODzaeZ3_BNqThsh6XfZFLvoRp_Bx8",
    name: sprintf(tr("home_station_label"), [
      "Depok",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1S8x9QgKxvbH-DO9zXgFDVpJKTPzJdv64",
    name: sprintf(tr("home_station_label"), [
      "Bogor",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1QKLr7MjOj7s9xUaV5hjuwJz5BM9UAE03",
    name: sprintf(tr("home_station_label"), [
      "Pancasila",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1OXrQkyhpTY-irYx8CfQ4DCzuQwhONGJ9",
    name: sprintf(tr("home_station_label"), [
      "Bojong Gede",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1Gh-j2sNa3ZFOHLdAKA8FKPKnsQBJAXmi",
    name: sprintf(tr("home_station_label"), [
      "Manggarai",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=15By-AuiEFD11Re8GKCsymxnGHZKmKQ2I",
    name: sprintf(tr("home_station_label"), [
      "Bekasi",
    ]),
  ),
  SignCardData(
    imageUrl:
        "https://drive.google.com/uc?id=1F0gXsA7chjyuMT8mWd-ws6l8r26AaVFv",
    name: sprintf(tr("home_station_label"), [
      "UI",
    ]),
  ),
];

class SignLanguage extends StatefulWidget {
  @override
  _SignLanguageState createState() => _SignLanguageState();
}

class _SignLanguageState extends State<SignLanguage> {
  SignCardsViewType cardViewType;
  ContentViewType contentViewType;

  @override
  void initState() {
    super.initState();
    contentViewType = ContentViewType.cards;
    cardViewType = SignCardsViewType.card;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 24,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (contentViewType == ContentViewType.cards) return;

                    setState(() {
                      contentViewType = ContentViewType.cards;
                    });
                  },
                  child: SignCategoryIcon(
                    iconUrl: "assets/icons/cards.svg",
                    chosen: contentViewType == ContentViewType.cards,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (contentViewType == ContentViewType.videos) return;

                    setState(() {
                      contentViewType = ContentViewType.videos;
                    });
                  },
                  child: SignCategoryIcon(
                    iconUrl: "assets/icons/play.svg",
                    chosen: contentViewType == ContentViewType.videos,
                  ),
                ),
                Expanded(
                  child: SizedBox.shrink(),
                ),
                InkWell(
                  onTap: () {
                    if (cardViewType == SignCardsViewType.list) return;

                    setState(() {
                      cardViewType = SignCardsViewType.list;
                    });
                  },
                  child: SignCategoryIcon(
                    iconUrl: "assets/icons/list-view.svg",
                    chosen: this.cardViewType == SignCardsViewType.list,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (cardViewType == SignCardsViewType.card) return;

                    setState(() {
                      cardViewType = SignCardsViewType.card;
                    });
                  },
                  child: SignCategoryIcon(
                    iconUrl: "assets/icons/card-view.svg",
                    chosen: this.cardViewType == SignCardsViewType.card,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 16,
            ),
          ),
          Expanded(
            flex: 1,
            child: Visibility(
              replacement: ListView(
                padding: EdgeInsets.only(
                  bottom: 120,
                ),
                children: [
                  Video(youtubeId: 'z1rE8HdiP1o'),
                  Video(youtubeId: 'Im2AOi7bEWs'),
                  Video(youtubeId: 'hea5--m4h1s'),
                ],
              ),
              visible: contentViewType == ContentViewType.cards,
              child: SignCards(
                viewType: cardViewType,
                viewTypeOnChange: (SignCardsViewType viewType) {
                  setState(() {
                    cardViewType = viewType;
                  });
                },
                cards: signCards,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Video extends StatefulWidget {
  final String youtubeId;
  Video({
    Key key,
    this.youtubeId,
  }) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          liveUIColor: AppColor.blue(1),
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColor.blue(1),
          bottomActions: [
            CurrentPosition(),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
              ),
            ),
            ProgressBar(isExpanded: true),
          ],
        ),
        builder: (BuildContext context, Widget player) {
          return player;
        });
  }
}

class CardImage extends StatefulWidget {
  final String url;

  CardImage({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  _CardImageState createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CachedNetworkImage(
        imageUrl: widget.url,
        placeholder: (BuildContext context, __) {
          return SizedBox.expand(
            child: ContentPlaceholder(),
          );
        },
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}

enum SignCardsViewType {
  list,
  card,
}

class SignCardData {
  final String name;
  final String imageUrl;

  SignCardData({
    this.name,
    this.imageUrl,
  });
}

typedef CardOnSelect = Function(int index);
typedef CardViewTypeOnChange = Function(SignCardsViewType viewType);

class SignCards extends StatefulWidget {
  final SignCardsViewType viewType;
  final List<SignCardData> cards;
  final CardViewTypeOnChange viewTypeOnChange;

  SignCards({
    Key key,
    this.viewType = SignCardsViewType.card,
    this.cards,
    this.viewTypeOnChange,
  }) : super(key: key);

  @override
  _SignCardsState createState() => _SignCardsState();
}

class _SignCardsState extends State<SignCards> {
  int initialIndex;

  @override
  void initState() {
    super.initState();
    initialIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Visibility(
            visible: widget.viewType == SignCardsViewType.card,
            replacement: CardList(
              signCards: widget.cards,
              onSelect: (int index) {
                widget.viewTypeOnChange(SignCardsViewType.card);
                setState(() {
                  initialIndex = index;
                });
              },
            ),
            child: CardsView(
              initialIndex: initialIndex,
              signCards: widget.cards,
            ),
          ),
        )
      ],
    );
  }
}

class CardList extends StatelessWidget {
  final List<SignCardData> signCards;
  final CardOnSelect onSelect;

  CardList({
    Key key,
    @required this.signCards,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 200,
      ),
      child: IntrinsicHeight(
        child: SizedBox.expand(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: signCards
                .asMap()
                .map((int index, SignCardData data) {
                  return MapEntry(
                    index,
                    InkWell(
                      onTap: () {
                        onSelect(index);
                      },
                      child: Container(
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.white(1),
                          border: Border.all(
                            color: AppColor.black(1),
                            width: 0.5,
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                child: CardImage(
                                  url: data.imageUrl,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(
                                  data.name,
                                  style: TextStyle(
                                    color: AppColor.black(1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class CardsView extends StatefulWidget {
  final List<SignCardData> signCards;
  final int initialIndex;

  const CardsView({
    Key key,
    @required this.signCards,
    @required this.initialIndex,
  }) : super(key: key);

  @override
  _CardsViewState createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  PageController cardViewController;
  double currentPageIndex;

  @override
  void initState() {
    super.initState();

    currentPageIndex = (widget.initialIndex ?? 0).toDouble();
    cardViewController = PageController(
      initialPage: currentPageIndex.toInt(),
      viewportFraction: 0.7,
    );
    cardViewController.addListener(() {
      setState(() {
        currentPageIndex = cardViewController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: cardViewController,
      itemCount: widget.signCards.length,
      itemBuilder: (BuildContext context, int index) {
        int pageIndex = currentPageIndex.floor();
        double factor = index - currentPageIndex;

        if (index == pageIndex || index == pageIndex - 1) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, -(factor * 100.0), 0.0),
            child: SignCard(
              signCardData: widget.signCards[index],
            ),
          );
        } else if (index == pageIndex + 1 || index == pageIndex + 2) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, -(factor * 100.0), 0.0),
            child: SignCard(
              signCardData: widget.signCards[index],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class SignCard extends StatelessWidget {
  const SignCard({
    Key key,
    @required this.signCardData,
  }) : super(key: key);

  final SignCardData signCardData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white(1),
            boxShadow: [
              AppShadow.normalShadow,
            ],
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 350,
                  child: CardImage(
                    url: signCardData.imageUrl,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    this.signCardData.name,
                    style: TextStyle(
                      color: AppColor.black(1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignCategoryIcon extends StatelessWidget {
  final String iconUrl;
  final bool chosen;

  SignCategoryIcon({
    this.iconUrl,
    this.chosen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.chosen ? AppColor.grayLight(1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: SvgPicture.asset(
        iconUrl,
        height: 14,
      ),
    );
  }
}
