import 'package:flutter/material.dart';

// Horizontal Spacing
const Widget hSpace10 = SizedBox(width: 10.0);
const Widget hSpace5 = SizedBox(width: 5.0);
const Widget hSpace18 = SizedBox(width: 18.0);
const Widget hSpace25 = SizedBox(width: 25.0);
const Widget hSpace50 = SizedBox(width: 50.0);

// Vertical Spacing
const Widget vSpace5 = SizedBox(height: 5.0);
const Widget vSpace10 = SizedBox(height: 10.0);
const Widget vSpace18 = SizedBox(height: 18.0);
const Widget vSpace25 = SizedBox(height: 25.0);
const Widget vSpace50 = SizedBox(height: 50.0);

// Screen Size helpers

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

class Spacers  {
  
}