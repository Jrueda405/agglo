import 'package:agglo/Helper/SharedPreferencesHelper.dart';
import 'package:agglo/Screens/MapView.dart';
import 'package:agglo/model/Constant.dart';
import 'package:agglo/styles/AggloColors.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String _currentSelectedValue = idTypes.first;
  final TextEditingController controllerId= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Center(
                    child: Text(
                      'Agglo',
                      style:
                      TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold,letterSpacing: 1.5,),
                    ),
                  )
                ),

              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'TIPO DE DOCUMENTO',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AggloColors.primaryColor))),
                        isEmpty: _currentSelectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentSelectedValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: idTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: controllerId,
                    decoration: InputDecoration(
                        labelText: 'NUMERO DE DOCUMENTO ',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AggloColors.primaryColor))),
                    obscureText: true,
                  ),
                  SizedBox(height: 30.0),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: AggloColors.primaryAccent,
                        color: AggloColors.primaryColor,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            if(controllerId.text.isNotEmpty){
                              SharedPreferencesHelper.setValue(SharedPreferencesHelper.IDENTIFICATION, controllerId.text);
                              SharedPreferencesHelper.setValue(SharedPreferencesHelper.TYPE_ID, _currentSelectedValue);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MapView(idCard: controllerId.text,)));
                            }
                          },
                          child: Center(
                            child: Text(
                              'CONTINUAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                ],
              )),
           SizedBox(height: 20.0),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Text(
                 'Solo se guardara la información dentro de tu dispositivo.',
                 style: TextStyle(
                   fontFamily: 'Montserrat',
                ),
              ),
           ],
           )
        ]));
  }
}