import 'package:flutter/material.dart';

class FaceCard extends StatefulWidget {
  FaceCard({Key key, this.text, this.path, @required this.selected})
      : super(key: key);

  final String text;
  final String path;
  final bool selected;

  @override
  State<StatefulWidget> createState() =>
      FaceCardState(initialSelected: selected);
}

class FaceCardState extends State<FaceCard> {
  FaceCardState({this.initialSelected});

  bool initialSelected;
  bool _selected;
  bool notNull(Object o) => o != null;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void _toggleSelected() {
    setState(() {
      _selected = !_selected;
    });
    print('Card tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: _toggleSelected,
          child: Container(
            // width: 300,
            // height: 100,
            color: Colors.red,
            child: Column(
              children: [
                this._selected ? Icon(Icons.check) : null,
                Image.asset(widget.path),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                Text(widget.text),
              ].where(notNull).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
