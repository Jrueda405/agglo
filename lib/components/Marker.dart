import 'package:flutter/material.dart';

class MarkerPaint extends CustomPainter {

  final String _marketname;
  final int _people;
  final String _size;

  MarkerPaint(this._marketname, this._people, this._size);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(10));

    paint.color =Colors.white;
    canvas.drawRRect(rRect, paint);

    paint.color =Colors.deepPurple;
    canvas.drawCircle(Offset(20,size.height/2), 10, paint);

    paint.color =Colors.red;
    canvas.drawCircle(Offset(size.width*0.75,size.height/2), 10, paint);

    final textPainter= TextPainter(
      text: TextSpan(
        text: _marketname,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        )
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width-20-20);
    textPainter.paint(canvas, Offset(40, size.height/2 - textPainter.size.height/2));

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
    //throw UnimplementedError();
  }


}