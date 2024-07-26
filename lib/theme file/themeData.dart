import 'package:flutter/material.dart';

import 'textTheme.dart';

class Mytheme {
  Mytheme._();
  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    textTheme: Texttheme.lighttext,
  );

  static ThemeData darktheme = ThemeData(
    useMaterial3: true,
    textTheme: Texttheme.darktext,
  );
}