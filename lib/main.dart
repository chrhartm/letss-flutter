import 'package:flutter/material.dart';
import 'MatchCard.dart';
import 'signupForms.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
  runApp(App());
}

// From firebase init docs
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Loading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Letss - Loading",
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Center(
                heightFactor: 10,
                // Show logo instead moving up and down
                child: Text('Loading'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Letss';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.grey[800],
        accentColor: Colors.orange[600],

        // Define the default font family.
        fontFamily: 'Roboto',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, color: Colors.black, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, color: Colors.black, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          button: TextStyle(fontSize:26)
        )
      ),
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
  // User auth
  bool _signedIn = false;
  var currentUser = FirebaseAuth.instance.currentUser;

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
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        _signedIn = false;
        currentUser = FirebaseAuth.instance.currentUser;
      } else {
        _signedIn = true;
      }
    });
    if (_signedIn) {
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
    } else {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome', 
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'What\'s your email?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(height: 30),
                EmailForm(),
              ],
            ),
          ),
        ),
      );
    }
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
