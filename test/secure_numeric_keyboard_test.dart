import 'package:flutter_test/flutter_test.dart';
import 'package:secure_numeric_keyboard/secure_numeric_keyboard.dart';
import 'package:secure_numeric_keyboard/secure_numeric_keyboard_platform_interface.dart';
import 'package:secure_numeric_keyboard/secure_numeric_keyboard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSecureNumericKeyboardPlatform
//     with MockPlatformInterfaceMixin
//     implements SecureNumericKeyboardPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final SecureNumericKeyboardPlatform initialPlatform = SecureNumericKeyboardPlatform.instance;
//
//   test('$MethodChannelSecureNumericKeyboard is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSecureNumericKeyboard>());
//   });
//
//   test('getPlatformVersion', () async {
//     SecureNumericKeyboard secureNumericKeyboardPlugin = SecureNumericKeyboard();
//     MockSecureNumericKeyboardPlatform fakePlatform = MockSecureNumericKeyboardPlatform();
//     SecureNumericKeyboardPlatform.instance = fakePlatform;
//
//     expect(await secureNumericKeyboardPlugin.getPlatformVersion(), '42');
//   });
// }
