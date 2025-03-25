import 'package:flutter/material.dart';

/*// Custom Clipper to create the cloud shape
class CloudClipper extends CustomClipper<Path> {
  final bool isMe;
  CloudClipper({required this.isMe});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Define a cloud shape (adjust the path as per your desired cloud shape)
    if (isMe) {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(size.width * 0.2, size.height - 10, size.width * 0.4, size.height - 5);
      path.quadraticBezierTo(size.width * 0.6, size.height - 10, size.width * 0.8, size.height - 5);
      path.quadraticBezierTo(size.width, size.height - 10, size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(size.width * 0.2, size.height + 10, size.width * 0.4, size.height + 5);
      path.quadraticBezierTo(size.width * 0.6, size.height + 10, size.width * 0.8, size.height + 5);
      path.quadraticBezierTo(size.width, size.height + 10, size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

 */

class CloudShapeClipper extends CustomClipper<Path> {
  final bool isSender;

  CloudShapeClipper({required this.isSender});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (isSender) {
      // Cloud shape for sender
      path.moveTo(0, size.height * 0.3);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.3, size.height * 0.4);
      path.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.5, size.height * 0.3);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.7, size.height * 0.3);
      path.quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width, size.height * 0.3);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Cloud shape for receiver
      path.moveTo(0, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.1, size.height * 0.4, size.width * 0.3, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width * 0.7, size.height * 0.5);
      path.quadraticBezierTo(size.width * 0.9, size.height * 0.4, size.width, size.height * 0.5);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
