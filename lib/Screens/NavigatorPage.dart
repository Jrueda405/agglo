import 'package:agglo/Screens/Information.dart';
import 'package:agglo/Screens/Discounts.dart';


import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget{
  final String idCard;

  const NavigatorPage({Key key, this.idCard}) : super(key: key);
  @override
  _NavigatorPageState createState() {
    return _NavigatorPageState();
  }

}

class _NavigatorPageState extends State<NavigatorPage>{
  
  Widget _widget;
  int indexTab=0;

  @override
  void initState() {
    super.initState();
    _widget=Information(idCard: widget.idCard,);
  }

  @override
  Widget build(BuildContext context) {
    print("tab"+indexTab.toString());
    return Scaffold(
      appBar: indexTab==0?AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff134f6a),
        title: Text("Agglo", style: TextStyle(color: Colors.white),),
      ):null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people),title: Text("Información")),
          BottomNavigationBarItem(icon: Icon(Icons.star), title: Text("Promociones")),
        ],
        onTap: (int i){
          switch(i){
            case 0:  setState(() {
              indexTab=i;
              _widget=Information(idCard: widget.idCard,);
            }); break;
            case 1: setState(() {
              indexTab=i;
              _widget=Discounts();
            }); break;
            default: break;
          }
        },
      ),
      body: _widget,

    );
  }



}