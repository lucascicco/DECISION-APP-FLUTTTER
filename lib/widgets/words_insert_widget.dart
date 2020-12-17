import 'package:decision_app/models/insert_text.dart';
import 'package:flutter/material.dart';
import '../models/insert_text.dart';
import 'dart:core';

class HandlingData extends StatefulWidget {
  final Function _addNewDecision;
  final List<InsertText> _userDecisions;

  const HandlingData(this._addNewDecision, this._userDecisions);

  @override
  _HandlingDataState createState() => _HandlingDataState();
}

class _HandlingDataState extends State<HandlingData> {
  final _decisionText = TextEditingController();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro na inserção'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Entendi'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submitData(BuildContext context) {
    int itAlreadyExists = widget._userDecisions
        .indexWhere((item) => item.title == _decisionText.text);

    if (_decisionText.text.isEmpty ||
        widget._userDecisions.length > 9 ||
        itAlreadyExists != -1) {
      return _showErrorDialog(context,
          'Palavras repetidas e vazias não serão aceitas, e também, verifique o limite.');
    }

    widget._addNewDecision(_decisionText.text);
    _showSnackBar(context, _decisionText.text.trim());
    _decisionText.text = '';
  }

  void _showSnackBar(BuildContext context, String option) {
    final snackBar = SnackBar(
      content: Text('Opção "$option" adiciona na lista'),
      duration: Duration(seconds: 1),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = widget._userDecisions.length.toString();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextField(
            maxLength: 20,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              labelText: 'Escreva uma opção',
              labelStyle: TextStyle(fontSize: 18, color: Colors.black),
              contentPadding: EdgeInsets.zero,
              suffixStyle: TextStyle(fontSize: 18, color: Colors.purple),
              hintText: 'Digite uma opção',
              helperText: 'Mín 2. Máx 10. $currentLength/10 opções',
            ),
            controller: _decisionText,
            keyboardType: TextInputType.text,
            onSubmitted: (_) => _submitData(context),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Adicionar opção'),
                onPressed: () => _submitData(context),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    elevation: 1.5,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ))),
          )
        ],
      ),
    );
  }
}
