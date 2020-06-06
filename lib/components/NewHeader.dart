import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewHeader extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  final TextField textField;
  final String title;
  
  final Color color;

  NewHeader(
      {Key key,
      @required this.color,
      @required this.height,
      @required this.title,
      @required this.textField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          color: color,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 27),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
            child: Card(
              elevation: 6.0,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: textField),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
