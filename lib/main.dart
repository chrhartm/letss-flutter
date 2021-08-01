import 'package:flutter/material.dart';
import 'MatchCard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Letss';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Widget> _widgetOptions = <Widget>[];
  List<Widget> _cardList = [];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _removeCard() {
    setState(() {
      _cardList.removeLast();
      _widgetOptions = _getWidgetOptions(_cardList);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _cardList = _getMatchCard();
    _widgetOptions = _getWidgetOptions(_cardList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pan_tool),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
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

  List<Widget> _getWidgetOptions(cardList) {
    return [
      Stack(
        alignment: Alignment.center,
        children: cardList,
      ),
      Text(
        'Likes',
        style: optionStyle,
      ),
      Text(
        'Chats',
        style: optionStyle,
      ),
      Text(
        'Profile',
        style: optionStyle,
      ),
    ];
  }
}
