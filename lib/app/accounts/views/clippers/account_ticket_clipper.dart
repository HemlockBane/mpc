import 'package:flutter/material.dart';

class AccountTransactionsTicketClipper extends CustomClipper<Path> {


  Path getPath(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var xIncrement = size.width / 29;
    while (curXPos < size.width) {
      curXPos += xIncrement;
      curYPos = curYPos == size.height ? size.height - 21 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);

    return path;
  }


  @override
  Path getClip(Size size) {
    Path path = getPath(size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
