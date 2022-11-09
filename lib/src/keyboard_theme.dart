
import 'package:flutter/material.dart';

class KeyboardTheme  {

  /// The height of the key input monitor.
  // double kKeyInputMonitorHeight = 50.0;
  // double? keyHeight = 50.0;

  /// The default height of the keyboard.
  // double kKeyboardDefaultHeight = 280.0;
  double? keypadHeight = 260.0;
  double? keyboardHeight = 293.0; //android 293,

  /// The default radius of the keyboard key.
  // double kKeyboardKeyDefaultRadius = 4.0;
  double? keyRadius = 4.0;

  /// The default spacing of the keyboard key.
  // double kKeyboardKeyDefaultSpacing = 1.2;
  double? keySpacing = 1.2;

  /// The delay at which the entered text is erased when holding backspace.
  // int kBackspaceEventDelay = 100;

  /// The default background color of the keyboard.
  // Color kKeyboardDefaultBackgroundColor = const Color(0xFF0A0A0A);
  // Color backgroundColor = const Color(0xFF363D4B);
  Color? backgroundColor = Colors.white;

  /// The default color of the string key.
  // Color kKeyboardDefaultStringKeyColor = const Color(0xFF313131);
  // Color keyBackgroundColor = const Color(0xFF38404F);
  Color? keyBackgroundColor = Colors.white;

  bool? showTopShadow = false;
  // Color? topShadowColor = const Color(0xFFF5F5F5);
  Color? topShadowColor = const Color(0xFFF5F5F5);
  // double? shadowHeight = 20.0;



  /// The default text style of the text inside the keyboard key.
  // TextStyle kKeyboardDefaultKeyTextStyle = const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500);
  TextStyle? textStyle = const TextStyle(color: Color(0xFF757491), fontSize: 17.0, fontWeight: FontWeight.w500);

  /// The de

  /// The default padding of the keyboard.
  // EdgeInsetsGeometry kKeyboardDefaultPadding = const EdgeInsets.symmetric(horizontal: 5.0);
  EdgeInsetsGeometry? keyDefaultPadding = const EdgeInsets.symmetric(horizontal: 5.0);

  KeyboardTheme({
    // this.keyHeight,
    this.keypadHeight = 260,
    this.keyboardHeight = 293,
    this.keyRadius = 4.0,
    this.keySpacing = 1.2,
    this.backgroundColor = Colors.white,
    this.keyBackgroundColor = Colors.white,
    this.showTopShadow = false,
    this.topShadowColor = const Color(0xFFF5F5F5),
    this.textStyle = const TextStyle(color: Color(0xFF757491), fontSize: 17.0, fontWeight: FontWeight.w500),
    this.keyDefaultPadding = const EdgeInsets.symmetric(horizontal: 5.0)
  }) {

  }
}