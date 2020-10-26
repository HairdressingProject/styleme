import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:app/views/pages/my_account.dart';
import 'package:flutter/material.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/views/pages/sign_in.dart';
import 'package:app/views/pages/sign_up.dart';

DrawerHeader buildDrawerHeader(BuildContext context, User user) {
  return DrawerHeader(
      child: Column(
    children: [
      Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 32.0,
              ))),
      const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
      Column(
        children: [
          Container(
            // padding: const EdgeInsets.only(top: 50.0),
            alignment: Alignment.centerLeft,
            child: Icon(Icons.account_circle),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Container(
              alignment: Alignment.centerLeft,
              // padding: const EdgeInsets.only(top: 80.0),
              child: Text(
                user.username,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontFamily: 'Klavika'),
              )),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Container(
            alignment: Alignment.centerLeft,
            // padding: const EdgeInsets.only(top: 100.0),
            child: Text(
              user.userRole,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontFamily: 'Klavika'),
            ),
          ),
        ],
      ),
    ],
  ));
}

List<ListTile> buildDefaultDrawerItems(BuildContext context, User user) {
  return [
    ListTile(
      title: Row(
        children: [
          Icon(Icons.home),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('Home'),
        ],
      ),
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(user: user)))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.image),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('My Pictures'),
        ],
      ),
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => null))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.account_circle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('My Account'),
        ],
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyAccount(user: user),
            ))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.settings),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('Settings'),
        ],
      ),
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => null))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.help),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('Help'),
        ],
      ),
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.info),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('About')
        ],
      ),
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()))
      },
    ),
    ListTile(
      title: Row(
        children: [
          Icon(Icons.exit_to_app),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Text('Log out'),
        ],
      ),
      onTap: () async {
        await Authentication.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      },
    ),
  ];
}

class Layout extends StatelessWidget {
  Layout(
      {Key key,
      this.scaffoldKey,
      this.header,
      this.body,
      this.title,
      this.drawerHeader,
      this.drawerItems,
      @required this.user})
      : super(key: key);

  final Key scaffoldKey;
  final User user;
  final String header;
  final String title;
  final DrawerHeader drawerHeader;
  final List<ListTile> drawerItems;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              buildDrawerHeader(context, user),
              ...buildDefaultDrawerItems(context, user)
            ],
          ),
        ),
        body: body);
  }
}
