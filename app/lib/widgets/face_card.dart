import 'package:flutter/material.dart';


class FaceCard extends StatelessWidget {
  FaceCard({Key key, this.text, this.path, this.icon, @required this.selected}) : super(key: key);

  final String text;
  final String path;
  bool selected;
  final Icon icon;
  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // Unselect the previous selected card and select the new one
            // update state ?
            this.selected = true;
            print('Card tapped.');
          },
          child: Container(
            // width: 300,
            // height: 100,
            color: Colors.red,
            child: Column(
              children: [
                this.selected ? Icon(Icons.check):null,
                Image.asset(path),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                Text(text),
              ].where(notNull).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
