import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard(
      {Key key,
      this.id,
      this.imgPath,
      @required this.label,
      @required this.select,
      this.modelPicture,
      this.type,
      this.selected = false})
      : super(key: key);

  final int id;
  final String imgPath;
  final String label;
  final bool selected;
  final String type;
  final Function select;
  final CachedNetworkImage modelPicture;

  Widget _getImg() {
    Widget img;
    try {
      if (type == 'modelPicture') {
        img = modelPicture;
      } else {
        img = Image.asset(imgPath);
      }
      return img;
    } catch (err) {
      img = Center(
        child: Icon(Icons.image),
      );
      return img;
    }
  }

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
                      height: 150,
                      child: _getImg(),
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
