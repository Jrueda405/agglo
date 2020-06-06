import 'package:agglo/model/Restriccion.dart';
import 'package:flutter/material.dart';

/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData]
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final Restriction restriction;
  ValueTile({this.restriction});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          this.restriction.dia,
          style: TextStyle(),
        ),
        SizedBox(
          height: 5,
        ),
        (restriction.id<=4)?Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Chip(
              label:
              Text("${restriction.endings[0]}"),
            ),
            SizedBox(width: 10,),
            Chip(
              label:
              Text("${restriction.endings[1]}"),
            ),
          ],
        ):Center(
          child: Text("Todas las cedulas tienen restricción"),
        ),
      ],
    );
  }
}
