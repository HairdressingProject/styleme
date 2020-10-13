import 'package:flutter/material.dart';

typedef String CustomFieldValidation(String input);

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {@required this.label,
      this.validation,
      this.setTouched,
      this.isPassword = false,
      this.errorMsg,
      this.isValid,
      this.isTouched,
      this.obscureText = false,
      this.toggleFieldVisibility,
      this.controller});

  final String label;
  final CustomFieldValidation validation;
  final Function setTouched;
  final String errorMsg;
  final bool isPassword;
  final bool isValid;
  final bool isTouched;
  final bool obscureText;
  final Function toggleFieldVisibility;
  final TextEditingController controller;

  Widget _generateSuffixIcons() {
    if (isPassword) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: toggleFieldVisibility,
                child: obscureText
                    ? Icon(Icons.visibility, color: Colors.black87)
                    : Icon(Icons.visibility_off, color: Colors.black)),
            const Padding(
              padding: EdgeInsets.only(right: 5.0),
            ),
            isTouched
                ? !isValid
                    ? Icon(Icons.clear, color: Colors.red)
                    : Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                : null
          ].where((element) => element != null).toList());
    }

    return isTouched
        ? !isValid
            ? Icon(Icons.clear, color: Colors.red)
            : Icon(
                Icons.check,
                color: Colors.green,
              )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: setTouched,
      onChanged: validation,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          .copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: label,
          helperText: errorMsg,
          helperStyle: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.red[600]),
          labelStyle: isTouched
              ? isValid
                  ? TextStyle(color: Colors.green[600])
                  : TextStyle(color: Colors.red)
              : TextStyle(color: Colors.black),
          errorStyle: TextStyle(fontSize: 14.0),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0)),
          enabledBorder: isTouched
              ? isValid
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0))
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0)),
          focusedBorder: isValid
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0))
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0)),
          suffixIcon: _generateSuffixIcons()),
      validator: validation,
      controller: controller,
    );
  }
}
