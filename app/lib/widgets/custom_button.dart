
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({Key key, this.icon, @required this.text, @required this.enabled, this.action}) : super(key: key);

  final String text;
  final Icon icon;
  final bool enabled;
  Widget action;

  bool notNull(Object o) => o != null;
  @override
  Widget build(BuildContext context) {
    return
    MaterialButton(
      onPressed: this.enabled ? () {Navigator.push(context, MaterialPageRoute(builder: (context) => action ?? null));} : null, 
      color: Theme.of(context).buttonColor,
      disabledColor: Theme.of(context).disabledColor,
      height: MediaQuery.of(context).size.height / 15,
      minWidth: double.infinity,
      child: Row(
        children: [
          this.icon ?? null,
          // notNull(this.icon) ? const Padding(padding: EdgeInsets.only(left: 15.0)) : null,
          Expanded(child: Text(this.text, textAlign: TextAlign.center,),),
        ].where(notNull).toList(),
      ),
    );
  }
}