import 'dart:math';

import 'package:secure_numeric_keyboard/secure_numeric_keyboard.dart';

import 'secure_numeric_keyboard_key.dart';
import 'secure_numeric_keyboard_key_action.dart';
import 'secure_numeric_keyboard_key_type.dart';

/// A class responsible for key generation of the secure keyboard.
class SecureNumericKeyboardKeyGenerator {
  SecureNumericKeyboardKeyGenerator._internal();
  static final instance = SecureNumericKeyboardKeyGenerator._internal();

  // Maximum length of a row of numeric key.
  // If not enough, fill in the blank action key.
  final int _numericKeyRowMaxLength = 4;
  // final List<List<String>> _numericKeyRows = [
  //   const ['1', '2', '3'],
  //   const ['4', '5', '6'],
  //   const ['7', '8', '9'],
  //   const ['', '0', 'x']
  // ];
  final List<String> _numericKeyRows = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '', '0', 'x',
    // '', '', '',
  ];

  final String KEY_BACKSPACE = 'x';
  final String KEY_BLANK = '';


  /// Returns a list of numeric key rows.
  List<List<SecureNumericKeyboardKey>> getKeypad(bool shuffle) {

    var keyBuffer = List.from(_numericKeyRows); //copy
    if (shuffle) {
      keyBuffer.shuffle();
    }

    List<List<SecureNumericKeyboardKey>> keypad = [];
    int colSize = 3;
    for(int row = 0; row < keyBuffer.length / colSize; row++) {
      List<SecureNumericKeyboardKey> rowKeys = [];
      for(int col = 0; col < colSize; col++) {
        int index = row * colSize + col;
        rowKeys.add(_buildKeypad(keyBuffer[index]));
      }
      if(rowKeys.isNotEmpty) {
        keypad.add(rowKeys);
      }
    }

    return keypad;
  }


  SecureNumericKeyboardKey _buildKeypad(String key) {
    if(key == KEY_BACKSPACE) {
      return _backspaceActionKey();
    } else if(key == KEY_BLANK) {
      return _blankActionKey();
    }
    return SecureNumericKeyboardKey(text: key, type: SecureNumericKeyboardKeyType.STRING);
  }

  List<SecureNumericKeyboardKey> _buildKeyRow(List<List<String>> keyRows, int rowNum) {
    String key;
    return List.generate(keyRows[rowNum].length, (int keyNum) {
      key = keyRows[rowNum][keyNum];

      if(key == KEY_BACKSPACE) {
        return _backspaceActionKey();
      } else if(key == KEY_BLANK) {
        return _blankActionKey();
      }

      return SecureNumericKeyboardKey(text: key, type: SecureNumericKeyboardKeyType.STRING);
    });
  }


  // Create a string type key row.
  List<SecureNumericKeyboardKey> _buildStringKeyRow(List<List<String>> keyRows, int rowNum) {
    String key;
    return List.generate(keyRows[rowNum].length, (int keyNum) {
      key = keyRows[rowNum][keyNum];
      return SecureNumericKeyboardKey(text: key, type: SecureNumericKeyboardKeyType.STRING);
    });
  }

  // Create a backspace action key.
  SecureNumericKeyboardKey _backspaceActionKey() {
    return const SecureNumericKeyboardKey(
      type: SecureNumericKeyboardKeyType.ACTION,
      action: SecureNumericKeyboardKeyAction.BACKSPACE
    );
  }

  // Build a blank action key.
  SecureNumericKeyboardKey _blankActionKey() {
    return const SecureNumericKeyboardKey(
      type: SecureNumericKeyboardKeyType.ACTION,
      action: SecureNumericKeyboardKeyAction.BLANK
    );
  }
}
