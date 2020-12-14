import 'package:flutter/material.dart';

class ListOfItems extends StatelessWidget {
  final _listDecisions;

  ListOfItems(this._listDecisions);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [..._listDecisions.map((item) => Text(item.title)).toList()],
    ));
  }
}
