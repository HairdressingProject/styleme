import 'package:app/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/views/pages/sign_in.dart';
import 'package:app/views/pages/sign_up.dart';

const DrawerHeader defaultDrawerHeader = DrawerHeader(
  child: Center(
      child: Text('Menu',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ))),
);

List<ListTile> buildDefaultDrawerItems(BuildContext context) {
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()))
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => null))
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
      this.header,
      this.body,
      this.title,
      this.drawerHeader = defaultDrawerHeader,
      this.drawerItems})
      : super(key: key);

  final String header;
  final String title;
  final DrawerHeader drawerHeader;
  final List<ListTile> drawerItems;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [drawerHeader, ...drawerItems],
          ),
        ),
        body: body);
  }
}
