import 'package:flutter/material.dart';

extension widgets on Widget {
  Widget left() {
    return Align(
      alignment: Alignment.centerLeft,
      child: this,
    );
  }

  Widget right() {
    return Align(
      alignment: Alignment.centerRight,
      child: this,
    );
  }

  Widget space(
      {double bottom = 10, double left: 0, double top: 0, double right: 0}) {
    return Container(
      child: this,
      margin:
          EdgeInsets.only(bottom: bottom, left: left, right: right, top: top),
    );
  }
}
