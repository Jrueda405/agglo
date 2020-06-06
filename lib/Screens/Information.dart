import 'package:agglo/Helper/SharedPreferencesHelper.dart';
import 'package:agglo/Screens/SignUP.dart';
import 'package:agglo/components/InfoWidget.dart';
import 'package:agglo/model/Constant.dart';
import 'package:agglo/model/Restriccion.dart';
import 'package:flutter/material.dart';

class Information extends StatefulWidget {
  final String idCard;

  const Information({Key key, this.idCard}) : super(key: key);
  @override
  _InformationState createState() {
    return _InformationState();
  }
}

class _InformationState extends State<Information> with TickerProviderStateMixin{
  static const POSITIVE_PHRASE =
      "Puedes salir, recuerda siempre tomar todas las precaciones al salir y regresar a casa.";
  static const NEGATIVE_PHRASE =
      "Hoy no te corresponde salir, espera a que sea tu dia, se responsable.";
  static const MESSAGE_HOLIDAY = "Todas las cedulas tienen restricción";

  var indexDay = 0;
  List<int> indices;
  Restriction currentRestriction;

  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    DateTime now = DateTime.now();
    indexDay = (now.weekday - 1);
    indices = new List.generate(restrictions.length, (index) => index);
    indices.removeAt(indexDay);
    currentRestriction = restrictions[indexDay];

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
        ),
        child: Column(
          children: [
            Expanded(
              child: PeakAndIdWidget(currentRestriction: currentRestriction,info: getInfoText(),idCard: widget.idCard),
            ),
            _buildLoginBtn()
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _validateIfCanLeaveHome(int lastDigitId, Restriction restriction) {
    return restriction.endings.contains(lastDigitId) ? true : false;
  }

  String getInfoText(){
    if(indexDay>6){
    return MESSAGE_HOLIDAY;
    }else{
      if(currentRestriction.endings.contains(int.tryParse(widget.idCard.substring(widget.idCard.length-1)))==false){
        return POSITIVE_PHRASE;
      }else{
        return NEGATIVE_PHRASE;
      }
    }
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          SharedPreferencesHelper.setValue(SharedPreferencesHelper.IDENTIFICATION, null);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage()));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SALIR',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
