import 'package:flutter/material.dart';
import 'package:flutter_andreafirst/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required  String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : assert (text != null),
        super(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
            color: color,
            onPressed: onPressed);
}
