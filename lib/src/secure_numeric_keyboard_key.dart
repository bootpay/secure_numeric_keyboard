 

import 'secure_numeric_keyboard_key_action.dart';
import 'secure_numeric_keyboard_key_type.dart';

/// A model representing secure keyboard keys.
class SecureNumericKeyboardKey {
  /// The text of [SecureNumericKeyboardKey].
  final String? text;

  /// The type of [SecureNumericKeyboardKey].
  final SecureNumericKeyboardKeyType type;

  /// The action of [SecureNumericKeyboardKey].
  final SecureNumericKeyboardKeyAction? action;

  /// Constructs an instance of [SecureNumericKeyboardKey].
  const SecureNumericKeyboardKey({
    this.text,
    required this.type,
    this.action
  });

  /// Generate [SecureNumericKeyboardKey] model from [json].
  factory SecureNumericKeyboardKey.fromJson(Map<String, dynamic> json) {
    return SecureNumericKeyboardKey(
      text: json['text'],
      type: json['type'],
      action: json['action']
    );
  }

  /// Returns the data field of [SecureNumericKeyboardKey] in JSON format.
  Map<String, dynamic> toJson({bool toUpperText = false}) {
    return {
      'text': toUpperText
          ? text?.toUpperCase()
          : text,
      'type': type,
      'action': action
    };
  }
}
