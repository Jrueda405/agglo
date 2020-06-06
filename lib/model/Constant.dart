import 'package:flutter/material.dart';

import 'Restriccion.dart';


var idTypes = [
  "Cedula de ciudadania",
  "Tarjeta de identidad",
  "Cedula de extranjeria",
  "Pasaporte",
];

String stringSVGStore='<svg viewBox="16.0 21.0 45.0 36.0" ><path transform="translate(16.0, 21.0)" d="M 22.5 27 L 9 27 L 9 15.75 L 4.5 15.75 L 4.5 33.75 C 4.5 34.99452972412109 5.505468845367432 36 6.75 36 L 24.75 36 C 25.99453163146973 36 27 34.99452972412109 27 33.75 L 27 15.75 L 22.5 15.75 L 22.5 27 Z M 44.62031173706055 9.998437881469727 L 38.62265396118164 0.9984378814697266 C 38.20077896118164 0.3726566433906555 37.49765396118164 3.576278686523438e-07 36.74531173706055 3.576278686523438e-07 L 8.254687309265137 3.576278686523438e-07 C 7.502343654632568 3.576278686523438e-07 6.799218654632568 0.3726566135883331 6.384374618530273 0.9984378814697266 L 0.3867182731628418 9.998437881469727 C -0.6117192506790161 11.49609375 0.4570307731628418 13.5 2.257030725479126 13.5 L 42.75 13.5 C 44.54296875 13.5 45.61171722412109 11.49609375 44.62031173706055 9.998437881469727 Z M 36 34.875 C 36 35.49375152587891 36.50624847412109 36 37.125 36 L 39.375 36 C 39.99375152587891 36 40.5 35.49375152587891 40.5 34.875 L 40.5 15.75 L 36 15.75 L 36 34.875 Z" fill="#134f6a" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
String stringSVGUser='<svg viewBox="0.0 0.0 36.0 36.0" ><path  d="M 18 20.25 C 23.58984375 20.25 28.125 15.71484375 28.125 10.125 C 28.125 4.53515625 23.58984375 0 18 0 C 12.41015625 0 7.875 4.53515625 7.875 10.125 C 7.875 15.71484375 12.41015625 20.25 18 20.25 Z M 27 22.5 L 23.12578201293945 22.5 C 21.56484413146973 23.21718788146973 19.828125 23.625 18 23.625 C 16.171875 23.625 14.44218730926514 23.21718788146973 12.87421894073486 22.5 L 9 22.5 C 4.028906345367432 22.5 0 26.52890586853027 0 31.5 L 0 32.625 C 0 34.48828125 1.51171875 36 3.375 36 L 32.625 36 C 34.48828125 36 36 34.48828125 36 32.625 L 36 31.5 C 36 26.52890586853027 31.97109413146973 22.5 27 22.5 Z" fill="#134f6a" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

List categories = [
  {
    "name": "Supermercados",
    "color1": Color.fromARGB(100, 0, 0, 0),
    "color2": Color.fromARGB(100, 0, 0, 0),
  },

];


List stores = [
  {
    "title": "El mercatto",
    "address": "Bucaramanga",
    "rating": "4.5"
  },
  {
    "title": "Panaderia la suprema",
    "address": "Bucaramanga",
    "rating": "4.5"
  },


];


List<Restriction> restrictions = [
  new Restriction(0,"Lunes", [1, 2]),
  new Restriction(1,"Martes", [3, 4]),
  new Restriction(2,"Miercoles", [5, 6]),
  new Restriction(3,"Jueves", [7, 8]),
  new Restriction(4,"Viernes", [9, 0]),
  new Restriction(5,"Sabado", [null, null]),
  new Restriction(6,"Domingo", [null, null]),
];
