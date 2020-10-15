import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';

class SelectFaceShape extends StatelessWidget {
  static final String routeName = '/selectFaceShapeRoute';
  SelectFaceShape({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Select Face Shape',
        drawerItems: buildDefaultDrawerItems(context),
        body: Text('Select face shape'));
  }
}
