import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key key,
      this.icon,
      @required this.text,
      this.enabled = true,
      this.alreadySelected = false,
      this.action})
      : super(key: key);

  final String text;
  final Widget icon;
  final bool enabled;
  final bool alreadySelected;
  final Widget action;

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.enabled
          ? () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => action ?? null));
            }
          : null,
      color: alreadySelected
          ? Color.fromARGB(255, 38, 166, 154)
          : Color.fromARGB(255, 74, 169, 242),
      disabledColor: Theme.of(context).disabledColor,
      disabledTextColor: Colors.white,
      height: 45.00,
      minWidth: double.infinity,
      child: Row(
        children: [
          this.icon ?? null,
          Expanded(
            child: Text(
              this.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ].where(notNull).toList(),
      ),
    );
  }
}
