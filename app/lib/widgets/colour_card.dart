import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColourCard extends StatelessWidget {
  const ColourCard(
      {Key key,
      @required this.select,
      this.selected = false,
      @required this.colourHash,
      @required this.colourName,
      @required this.colourLabel})
      : super(key: key);

  final Function select;
  final bool selected;
  final String colourLabel;
  final String colourName;
  final String colourHash;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          select(this);
        },
        child: Container(
          child: Card(
            shadowColor: selected ? Colors.green[100] : null,
            color: selected ? Colors.green[50] : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        colourLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontFamily: 'Klavika', fontSize: 14),
                      ),
                    ),
                    selected
                        ? Container(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          )
                        : null
                  ].where((element) => element != null).toList(),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  color: HexColor(colourHash),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                Text(
                  colourHash,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontFamily: 'Klavika',
                      color: selected ? Colors.green : Colors.black),
                )
              ],
            ),
          ),
        ));
  }
}
