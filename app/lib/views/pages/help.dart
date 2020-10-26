import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Help extends StatelessWidget {

  Help({Key key, }) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(
        'Help',
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
              'assets/icons/help_top.svg',
              semanticsLabel: 'Help',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Text('Help', style: Theme.of(context).textTheme.headline1),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                runSpacing: 5.0,
    
                children: [
                  Text('See the official',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                  ),
                  InkWell(
                    onTap: () {
                    },
                    child: Text('website', style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w700, color: Color.fromARGB(255, 124, 62, 233)))
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                  ),
                  Text('of this app find tutorials and more information about it.',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
