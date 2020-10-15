import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muter/commons/helper/helper.dart';

class SignLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 24,
      ),
      child: SignCards(
        cards: [
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
          SignCardData(
            imageUrl: "assets/signs/alphabet-c.png",
            name: "Alphabet C",
          ),
        ],
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

class SignCards extends StatefulWidget {
  final SignCardsViewType initialViewType;
  final List<SignCardData> cards;

  SignCards({
    Key key,
    this.initialViewType = SignCardsViewType.card,
    this.cards,
  }) : super(key: key);

  @override
  _SignCardsState createState() => _SignCardsState();
}

class _SignCardsState extends State<SignCards> {
  SignCardsViewType viewType;
  int cardViewInitialIndex;

  @override
  void initState() {
    super.initState();
    viewType = widget.initialViewType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    if (viewType == SignCardsViewType.list) return;

                    setState(() {
                      viewType = SignCardsViewType.list;
                    });
                  },
                  child: SignCardViewIcon(
                    iconUrl: "assets/icons/list-view.svg",
                    chosen: this.viewType == SignCardsViewType.list,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (viewType == SignCardsViewType.card) return;

                    setState(() {
                      viewType = SignCardsViewType.card;
                    });
                  },
                  child: SignCardViewIcon(
                    iconUrl: "assets/icons/card-view.svg",
                    chosen: this.viewType == SignCardsViewType.card,
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
              visible: viewType == SignCardsViewType.card,
              replacement: CardList(
                signCards: widget.cards,
                onSelect: (int index) => {
                  setState(() {
                    viewType = SignCardsViewType.card;
                    cardViewInitialIndex = index;
                  })
                },
              ),
              child: CardsView(
                initialIndex: cardViewInitialIndex,
                signCards: widget.cards,
              ),
            ),
          )
        ],
      ),
    );
  }
}

typedef CardOnSelect = Function(int index);

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
                        width: 100,
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
                                padding: EdgeInsets.all(16),
                                child: Image.asset(
                                  data.imageUrl,
                                  height: 80,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: SvgPicture.asset(
                                      'assets/arts/line-wave.svg',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        bottom: 4,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/arts/wave.svg',
                                      ),
                                    ),
                                  ),
                                ],
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
    this.initialIndex,
    @required this.signCards,
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.white(1),
          boxShadow: [
            AppShadow.normalShadow,
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Image.asset(
                this.signCardData.imageUrl,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SvgPicture.asset(
                      'assets/arts/line-wave.svg',
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        left: 8,
                        bottom: 4,
                      ),
                      child: SvgPicture.asset(
                        'assets/arts/wave.svg',
                      ),
                    ),
                  ),
                ],
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
    );
  }
}

class SignCardViewIcon extends StatelessWidget {
  final String iconUrl;
  final bool chosen;

  SignCardViewIcon({
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
