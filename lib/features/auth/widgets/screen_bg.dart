import 'package:flutter/material.dart';

class AuthBg extends StatelessWidget {
  final Widget child;
  const AuthBg({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/png/circles-sm-btm-left.png')),
        Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/png/circle-big-top-left.png')),
        Center(
          child: child,
        ),
      ],
    );
  }
}