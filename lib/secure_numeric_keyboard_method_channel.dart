import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'secure_numeric_keyboard_platform_interface.dart';

/// An implementation of [SecureNumericKeyboardPlatform] that uses method channels.
class MethodChannelSecureNumericKeyboard extends SecureNumericKeyboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('secure_numeric_keyboard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
