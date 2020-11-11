import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.extension,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 8),
        Text(
          'KYC-DEMO',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
