import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';
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
  bool animate = false;

  void _startGame() {
    setState(() {
      gameStatus = 2;
    });

    new Future.delayed(
        const Duration(seconds: 2), () => {_decideNow(), startX()});
  }

  void startX() {
    print('it has been called');
    setState(() {
      animate = true;
    });
  }

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

    int selectedIndex =
        availableIndexs[Random().nextInt(availableIndexs.length)];

    int _initialLoop = Random().nextInt(_userDecisions.length);

    setState(() {
      gameStatus = 3;
      indexSelected = selectedIndex;
      loopingIndex = _initialLoop;
    });

    _startTimer(selectedIndex, _initialLoop, availableIndexs.length == 2);
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

  void _startTimer(int _inicialIndex, int _inicialLoop, bool lastTty) {
    new Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _start = 2000;
          loopingIndex = _inicialIndex;
          _userDecisions[_inicialIndex].selected = true;
          gameStatus = lastTty ? 5 : 4;
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

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
            'Jogo da decisão',
          ))
        : AppBar(
            title: Text(
            'Jogo da decisão',
          ));
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = _buildAppBar();
    final mediaQuery = MediaQuery.of(context);
    final availableSpace = (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        _userDecisions.length.toDouble() /
        (10 + _userDecisions.length * 0.5);

    final pageBody = SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: gameStatus == 1 || gameStatus == 2
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (gameStatus == 1)
                  Column(children: [
                    Center(
                        child: HandlingData(_addNewDecision, _userDecisions)),
                    if (_userDecisions.length > 1)
                      ElevatedButton(
                          child: Text('Iniciar o jogo'),
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              elevation: 1.5,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ))),
                  ]),

                if (gameStatus == 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                // GAME RUNNING.
                if (gameStatus != 1 && gameStatus != 2)
                  Expanded(
                    child: Column(children: [
                      Text(_userDecisions[loopingIndex].title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      if (gameStatus != 5)
                        Container(
                            child: ElevatedButton(
                          child: Text(gameStatus == 3 && loopingIndex != null
                              ? 'Decidindo...'
                              : 'Decida'),
                          onPressed: gameStatus == 3 && loopingIndex != null
                              ? null
                              : _decideNow,
                        )),
                      ListOfItems(_userDecisions, loopingIndex, indexSelected,
                          availableSpace, animate)
                    ]),
                  ),

                if (gameStatus == 4 || gameStatus == 5)
                  ElevatedButton(
                      child: Text('Jogue novamente'),
                      onPressed: _resetGame,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          elevation: 1.5,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          )))
              ],
            )));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
          );
  }
}
