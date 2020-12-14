import 'package:flutter/material.dart';
import '../models/insert_text.dart';

class ListOfItems extends StatelessWidget {
  final _listDecisions;
  final loopingIndex;
  final indexSelected;

  ListOfItems(this._listDecisions, this.loopingIndex, this.indexSelected);

  Row _buildWidget(int index, var decision) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(decision.title,
          style: TextStyle(
            fontWeight: decision.selected ? FontWeight.bold : null,
            fontSize: 18,
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        color: Color.fromRGBO(220, 220, 220, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
          itemCount: _listDecisions.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _buildWidget(index, _listDecisions[index]),
            );
          }),
    );
  }
}
