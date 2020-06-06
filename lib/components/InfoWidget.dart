import 'package:agglo/components/DaysHorizontalWidget.dart';
import 'package:agglo/components/WeatherSwipePager.dart';
import 'package:agglo/model/Constant.dart';
import 'package:agglo/model/Restriccion.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class PeakAndIdWidget extends StatelessWidget {
  final Restriction currentRestriction;
  final String info;
  final idCard;
  PeakAndIdWidget({this.currentRestriction, this.info, this.idCard}) : assert(currentRestriction != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.currentRestriction.dia.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            this.info,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w100,
                letterSpacing: 1,
                fontSize: 15,
                ),
          ),
          SizedBox(
            height: 10,
          ),
          QrImage(
            data: this.idCard,
            version: QrVersions.auto,
            size: 120,
            gapless: true,
          ),
          Divider(
            height: 10,
          ),
          Text(
            "PICO Y CEDULA",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                fontSize: 20),
          ),
          WeatherSwipePager(restriction: currentRestriction,restrictions: restrictions,),
          /*Padding(
            child: Divider(
            ),
            padding: EdgeInsets.all(10),
          ),

          //ForecastHorizontal(restrictions: restrictions),
          Padding(
            child: Divider(
            ),
            padding: EdgeInsets.all(10),
          ),
*/
        ],
      ),
    );
  }
}
