import 'package:agglo/model/Restriccion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WeatherSwipePager extends StatelessWidget {
  const WeatherSwipePager({
    Key key,
    @required this.restriction, this.restrictions,
  }) : super(key: key);

  final Restriction restriction;
  final List<Restriction> restrictions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width/2,
      child: Swiper(
        itemCount: restrictions.length,
        index: 0,
        itemBuilder: (context, index) {
          final item= restrictions[index];
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(item.dia, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(index<=4?"Podran salir las cedulas terminadas en:":"Restricción total", style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 14),),
                      index<=4?Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: item.endings.map((e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Chip(label: Text(e.toString()),),
                        )).toList(),
                      ):SizedBox(height: 10,),
                    ],
                  ),

                ],
              ),
            ),
          );
        },
        pagination: new SwiperPagination(
            margin: new EdgeInsets.all(5.0),
            alignment: Alignment.topCenter,
            builder: new DotSwiperPaginationBuilder(
                size: 5,
                activeSize: 5,
               )),
      ),
    );
  }
}
