import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  ActionButton(
      {Key key,
      this.icon,
      @required this.text,
      this.enabled = true,
      this.alreadySelected = false,
      this.action,
      @required this.colour})
      : super(key: key);

  final String text;
  final Icon icon;
  final bool enabled;
  final bool alreadySelected;
  final Function action;
  final Color colour;

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.enabled
          ? action
          : null,
      color: colour,
      disabledColor: Theme.of(context).disabledColor,
      disabledTextColor: Colors.white,
      height: MediaQuery.of(context).size.height / 15,
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
