import 'package:flutter/material.dart';

class FaceCard extends StatelessWidget {
  FaceCard({Key key, this.text, this.path, })
      : super(key: key);

  final String text;
  final String path;
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
              children: [
                Image.asset(path),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                Text(text),
              ]
            ),
      ),
    );
  }

}





