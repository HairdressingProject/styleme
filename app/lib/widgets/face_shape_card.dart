import 'package:flutter/material.dart';

class FaceShapeCard extends StatelessWidget {
  const FaceShapeCard(
      {Key key,
      @required this.imgPath,
      @required this.label,
      @required this.select,
      this.selected = false})
      : super(key: key);

  final String imgPath;
  final String label;
  final bool selected;
  final Function select;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          select(this);
        },
        child: Card(
            shadowColor: selected ? Colors.green[100] : null,
            color: selected ? Colors.green[50] : null,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(imgPath),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontFamily: 'Klavika',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.green : Colors.black))
                  ],
                )
              ],
            )));
  }
}
