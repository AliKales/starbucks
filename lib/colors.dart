import 'package:flutter/material.dart';

const Color color1 = Colors.white;
const Color color2 = Color.fromARGB(255, 223, 223, 223);
const Color color3 = Color.fromARGB(255, 180, 147, 49);
const Color color4 = Color.fromARGB(255, 221, 213, 168);
const Color color5 = Color.fromARGB(255, 18, 95, 44);
const Color color6 = Color.fromARGB(255, 233, 233, 233);

class CustomColor {
  MaterialColor getMaterialColor(int r, int g, int b, int colorCode) {
    Map<int, Color> colorMap = {
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6),
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    };

    return MaterialColor(colorCode, colorMap);
  }
}
