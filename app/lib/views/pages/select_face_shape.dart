import 'package:app/widgets/logo_banner.dart';
import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/face_card.dart';

class SelectFaceShape extends StatelessWidget {
  static final String routeName = '/selectFaceShapeRoute';
  SelectFaceShape({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Select Face Shape',
        drawerItems: buildDefaultDrawerItems(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                FaceCard(text: 'Round', path: 'assets/icons/round.png',),
                FaceCard(text: 'Square', path: 'assets/icons/square.png',),
                FaceCard(text: 'Round', path: 'assets/icons/round.png',),
                FaceCard(text: 'Round', path: 'assets/icons/round.png',)
              ],
            )
          )
        )
      );
  }
}
