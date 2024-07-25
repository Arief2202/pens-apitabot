library globals;
import 'package:flutter/material.dart';

bool loadingAutologin = false;
bool isLoggedIn = false;
String endpoint = "0.0.0.0";

String name = "";
String nik = "";
String phone = "";
String email = "";
String key = "";
String iv = "";
String encrypted = "";

const int httpTimeout = 1;
const baseColor = MaterialColor(0xff0B114B, <int, Color>{
  50: Color(0xff0B114B),
  100: Color(0xff0B114B),
  200: Color(0xff0B114B),
  300: Color(0xff0B114B),
  400: Color(0xff0B114B),
  500: Color(0xff0B114B),
  600: Color(0xff0B114B),
  700: Color(0xff0B114B),
  800: Color(0xff0B114B),
  900: Color(0xff0B114B),
});
