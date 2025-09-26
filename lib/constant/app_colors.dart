import 'package:flutter/material.dart';

class AppColor {
  static const Color blackColor = Color.fromRGBO(24, 24, 27, 1);
  static const Color greyColor = Colors.grey;
  static const Color textGreyColor = Color.fromRGBO(134, 134, 134, 1);
  static const Color backgroundGreyColor = Color.fromRGBO(67, 67, 67, 0.32);
  static const Color greenColor = Colors.green;
  static const Color whiteColor = Colors.white;
  static const Color navColor = Color.fromRGBO(125, 147, 160, 1);
  static const Color blueColor = Color.fromRGBO(77, 197, 253, 1);
  static const Color redColor = Color.fromRGBO(202, 22, 54, 1);
  static const List<Color> blendColorList = [
    Color.fromRGBO(25, 161, 190, 1),
    Color.fromRGBO(125, 65, 146, 1),
    Colors.transparent,
  ];
  static const List<Color> gradientColorList = [
    Color.fromRGBO(25, 161, 190, 1),
    Color.fromRGBO(125, 65, 146, 1),
  ];
  static const List<Color> greenColorList = [
    Color.fromRGBO(180, 223, 134, 1),
    Color.fromRGBO(132, 199, 67, 1),
  ];
  static const Color lightBlueColor = Color.fromRGBO(184, 231, 255, 1);

 static List<List<Color>> playlistGradients = [
  [Colors.red.shade200, Colors.orange.shade200, Colors.pink.shade200],
  [Colors.blue.shade200, Colors.cyan.shade200, Colors.indigo.shade200],
  [Colors.green.shade200, Colors.teal.shade200, Colors.lime.shade200],
  [Colors.purple.shade200, Colors.deepPurple.shade200, Colors.pink.shade200],
  [Colors.orange.shade200, Colors.deepOrange.shade200, Colors.amber.shade200],
  [Colors.teal.shade200, Colors.cyan.shade200, Colors.blue.shade200],
  [Colors.pink.shade200, Colors.purple.shade200, Colors.deepPurple.shade200],
];
}
