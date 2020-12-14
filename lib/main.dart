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

  bool started = false;
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

  void _startGame() {
    int selectedIndex = Random().nextInt(_userDecisions.length);

    int _initialLoop =
        selectedIndex + 1 == _userDecisions.length ? 0 : selectedIndex + 1;

    print(
        'valor index inicial $selectedIndex, valor inicial do loop $_initialLoop');

    setState(() {
      started = true;
      indexSelected = selectedIndex;
      loopingIndex = _initialLoop;
    });

    _startTimer(selectedIndex, _initialLoop);
  }

  void _startTimer(int _inicialIndex, int _inicialLoop) {
    new Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _start = 4000;
          loopingIndex = _inicialIndex;
          timer.cancel();
        });
      } else {
        print('its has been called');
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
                if (started)
                  Container(child: Text(_userDecisions[loopingIndex].title)),
                HandlingData(_addNewDecision),
                if (_userDecisions.length > 1)
                  Container(
                    child: RaisedButton(
                      child: Text('Rodar decisão'),
                      onPressed: _startGame,
                    ),
                  ),
                ListOfItems(_userDecisions)
              ],
            )));
  }
}
