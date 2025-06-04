/*import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final Widget badgeContent;

  Badge({required this.child, required this.badgeContent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: badgeContent,
          ),
        ),
      ],
    );
  }
}*/// Display posts from the joined and created communities
