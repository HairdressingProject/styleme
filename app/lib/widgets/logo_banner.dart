import 'package:flutter/material.dart';

class LogoBanner extends StatelessWidget {
  LogoBanner({Key key, this.logoPath}) : super(key: key);

  final String logoPath;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Image.asset(logoPath),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        const Text(
          'Hairdressing Project',
          style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'Klavika'),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
