import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import './models/insert_text.dart';
import './widgets/words_insert_widget.dart';
import './widgets/list_words_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decision App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<InsertText> _userDecisions = [];
  int gameStatus = 1;
  int indexSelected;
  int loopingIndex;
  int _start = 4000;

  void _addNewDecision(String txTitle) {
    final newDecision = InsertText(
      title: txTitle,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userDecisions.add(newDecision);
    });
  }

  void _decideNow() {
    List<int> availableIndexs = _userDecisions
        .asMap()
        .entries
        .map((entry) {
          if (!entry.value.selected) {
            return entry.key;
          }
        })
        .where((item) => item != null)
        .toList();

    if (availableIndexs.length == 1) {
      // ask?
      return setState(() {
        gameStatus = 4;
      });
    }

    int selectedIndex =
        availableIndexs[Random().nextInt(availableIndexs.length)];

    int _initialLoop = Random().nextInt(_userDecisions.length);

    setState(() {
      gameStatus = 2;
      indexSelected = selectedIndex;
      loopingIndex = _initialLoop;
    });

    _startTimer(selectedIndex, _initialLoop);
  }

  void _resetGame() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => HomePage(),
      ),
    );
  }

  void _startTimer(int _inicialIndex, int _inicialLoop) {
    new Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _start = 2000;
          loopingIndex = _inicialIndex;
          _userDecisions[_inicialIndex].selected = true;
          gameStatus = 3;
          timer.cancel();
        });
      } else {
        setState(() {
          _start = _start - 200;
          loopingIndex =
              loopingIndex + 1 == _userDecisions.length ? 0 : loopingIndex + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Decision App'),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                if (gameStatus == 1) HandlingData(_addNewDecision),
                if (gameStatus != 1)
                  Container(child: Text(_userDecisions[loopingIndex].title)),
                if (_userDecisions.length > 1)
                  Container(
                    child: Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                              child: RaisedButton(
                            child: Text(
                                gameStatus == 2 ? 'Decidindo...' : 'Decida'),
                            onPressed: _decideNow,
                          )),
                          ListOfItems(
                              _userDecisions, loopingIndex, indexSelected)
                        ],
                      ),
                    ),
                  ),
                if (gameStatus == 3 || gameStatus == 4)
                  RaisedButton(
                      child: Text('Jogue novamente'), onPressed: _resetGame)
              ],
            )));
  }
}
