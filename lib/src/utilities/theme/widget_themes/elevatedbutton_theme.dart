import 'package:flutter/material.dart';
import 'package:washcubes_admindashboard/src/constants/colors.dart';

class CElevatedButtonTheme {
  CElevatedButtonTheme._(); //Avoid Creating Instances

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.cButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Button border radius
      ),
    ),
  );
}