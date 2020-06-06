import 'package:agglo/Helper/FirebaseHelper.dart';
import 'package:agglo/Helper/SharedPreferencesHelper.dart';
import 'package:agglo/Screens/MapView.dart';
import 'package:agglo/Screens/SignUP.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.load();
  await FirebaseHelper.instantiate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    String data = SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.IDENTIFICATION);
    return MaterialApp(
      title: 'Agglo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        fontFamily: 'Segoe UI',
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _checkIfUserHaveRegisteredId(data) == false
          ? SignupPage()
          : MapView(
        idCard: data,
      ),
    );
  }

  bool _checkIfUserHaveRegisteredId(String data) {
    return (data.isNotEmpty)? true: false;
  }

}
