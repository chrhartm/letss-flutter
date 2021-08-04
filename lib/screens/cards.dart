import 'package:flutter/material.dart';
import '../models/matchcard.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  List<Widget> _cardList = [];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _removeCard() {
    setState(() {
      _cardList.removeLast();
    });
  }

  @override
  void initState() {
    super.initState();
    _cardList = _getMatchCard();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _getMatchCard(),
    );
  }

  List<Widget> _getMatchCard() {
    List<MatchCard> cards = [];
    cards.add(MatchCard("Hans Mueller"));
    cards.add(MatchCard("Joe Johnson"));
    cards.add(MatchCard("Betty Bauer"));

    List<Widget> cardList = [];

    for (int x = 0; x < 3; x++) {
      cardList.add(Positioned(
        top: 5,
        child: Draggable(
          onDragEnd: (drag) {
            _removeCard();
          },
          childWhenDragging: Container(),
          feedback: Card(
            elevation: 5,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
                width: 240,
                height: 1000,
                child: Text(
                  cards[x].name,
                  style: optionStyle,
                )),
          ),
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
                width: 240,
                height: 1000,
                child: Text(
                  cards[x].name,
                  style: optionStyle,
                )),
          ),
        ),
      ));
    }

    return cardList;
  }
}
