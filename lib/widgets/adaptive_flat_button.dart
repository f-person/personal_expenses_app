import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  AdaptiveFlatButton({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: child,
            onPressed: onPressed,
          )
        : RaisedButton(
            child: child,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
            onPressed: onPressed,
          );
  }
}
