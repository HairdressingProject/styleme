import 'package:app/models/user.dart';
import 'package:app/services/notification.dart';
import 'package:app/widgets/my_account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAccount extends StatelessWidget {
  final User user;

  MyAccount({Key key, @required this.user}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNotify({@required String message}) {
    NotificationService.notify(scaffoldKey: scaffoldKey, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(
        'My Account',
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
              'assets/icons/my_account_top.svg',
              semanticsLabel: 'My account',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            Text('My Account', style: Theme.of(context).textTheme.headline1),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
            const Center(
                child: Icon(
              Icons.account_circle,
              size: 128,
            )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
            ),
            MyAccountForm(
              user: user,
              onNotify: _onNotify,
            )
          ],
        ),
      )),
    );
  }
}
