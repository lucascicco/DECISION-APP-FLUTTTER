import 'package:flutter/material.dart';

class HandlingData extends StatefulWidget {
  final Function _addNewDecision;

  const HandlingData(this._addNewDecision);

  @override
  _HandlingDataState createState() => _HandlingDataState();
}

class _HandlingDataState extends State<HandlingData> {
  final _decisionText = TextEditingController();

  void _submitData() {
    if (_decisionText.text.isEmpty) {
      return;
    }

    widget._addNewDecision(_decisionText.text);
    _decisionText.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Escreva sua decisão'),
            controller: _decisionText,
            keyboardType: TextInputType.text,
            onSubmitted: (_) => _submitData(),
          ),
          RaisedButton(
            child: Text('Adicionar decisão'),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }
}
