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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<InsertText> _userDecisions = [];
  int gameStatus = 1;
  int indexSelected;
  int loopingIndex;
  int _start = 4000;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _startGame() {
    setState(() {
      gameStatus = 2;
    });

    new Future.delayed(const Duration(seconds: 5), _decideNow);
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

    if (availableIndexs.length == 1) {
      return setState(() {
        gameStatus = 5;
      });
    }

    int selectedIndex =
        availableIndexs[Random().nextInt(availableIndexs.length)];

    int _initialLoop = Random().nextInt(_userDecisions.length);

    setState(() {
      gameStatus = 3;
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
          gameStatus = 4;
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

    final pageBody = SafeArea(
        child: AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
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
                if (gameStatus != 1)
                  Column(children: [
                    if (loopingIndex != null)
                      Text(_userDecisions[loopingIndex].title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    if (gameStatus != 1 && gameStatus != 2)
                      Container(
                        width: double.infinity,
                        child: Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                  child: ElevatedButton(
                                child: Text(
                                    gameStatus == 3 && loopingIndex != null
                                        ? 'Decidindo...'
                                        : 'Decida'),
                                onPressed: _decideNow,
                              )),
                              if (loopingIndex != null)
                                ListOfItems(
                                    _userDecisions, loopingIndex, indexSelected)
                            ],
                          ),
                        ),
                      ),
                  ]),

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
