import 'package:flutter/material.dart';
import '../models/insert_text.dart';

class ListOfItems extends StatefulWidget {
  final _listDecisions;
  final loopingIndex;
  final indexSelected;
  final heightAnimated;
  bool animate;

  ListOfItems(this._listDecisions, this.loopingIndex, this.indexSelected,
      this.heightAnimated, this.animate);

  @override
  _ListOfItemsState createState() => _ListOfItemsState();
}

class _ListOfItemsState extends State<ListOfItems> {
  Row _buildWidget(int index, InsertText decision) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(decision.title,
              style: TextStyle(
                fontWeight: decision.selected ? FontWeight.bold : null,
                fontSize: 18,
              )),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(10),
      duration: Duration(seconds: 5),
      curve: Curves.fastOutSlowIn,
      height: widget.animate ? widget.heightAnimated : 0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        color: Color.fromRGBO(220, 220, 220, 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget._listDecisions.length,
          itemBuilder: (ctx, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: widget._listDecisions[index].selected
                    ? Color.fromRGBO(220, 220, 220, 1.0)
                    : Color.fromRGBO(220, 220, 220, 0.3),
              ),
              child: _buildWidget(index, widget._listDecisions[index]),
            );
          }),
    );
  }
}
