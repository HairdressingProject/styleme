import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class About extends StatelessWidget {
  About({
    Key key,
  }) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(
        'About',
        style: TextStyle(fontFamily: 'Klavika'),
      )),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/about_top.svg',
              semanticsLabel: 'About',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Text('About', style: Theme.of(context).textTheme.headline1),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'This app was developed as a project assignment by Diploma of Software Development students at North Metropolitan TAFE',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.left),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('License: GPL - 3.0',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.left),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () {},
                  child: Text('Provide feedback',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 124, 62, 233)))),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () {},
                  child: Text('Privacy Policy',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 124, 62, 233)))),
            ),
          ],
        ),
      )),
    );
  }
}
