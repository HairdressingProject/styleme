import 'package:flutter/material.dart';
import 'package:style_me_flutter/views/layout.dart';

class Home extends StatelessWidget {
  static final String routeName = '/homeRoute';
  Home({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Home',
        drawerItems: buildDefaultDrawerItems(context),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              const Text(
                "Let's get stylish!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 24.0,
                    fontFamily: 'Klavika'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              // MoviesGallery()
              // buildMoviesGallery(context)
            ],
          ),
        )
      );
  }
}
