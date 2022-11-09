import 'dart:async';
import 'package:flutter/material.dart';
import 'keyboard_theme.dart';
import 'secure_numeric_keyboard.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'secure_numeric_keyboard_key.dart';

/// A widget that implements a secure keyboard with controller.
class WithNumericSecureKeyboard extends StatefulWidget {
  /// Controller to control the secure keyboard.
  final SecureKeyboardController controller;

  /// A child widget with a secure keyboard.
  final Widget child;

  // KeyboardTheme? keyboardTheme;

  /// Security Alert title, only works on iOS.
  final String? screenCaptureDetectedAlertTitle;

  /// Security Alert message, only works on iOS.
  final String? screenCaptureDetectedAlertMessage;

  /// Security Alert actionTitle, only works on iOS.
  final String? screenCaptureDetectedAlertActionTitle;

  /// Constructs an instance of [WithSecureKeyboard].
  WithNumericSecureKeyboard({
    Key? key,
    required this.controller,
    required this.child,
    this.screenCaptureDetectedAlertTitle,
    this.screenCaptureDetectedAlertMessage,
    this.screenCaptureDetectedAlertActionTitle
  })  : super(key: key);

  @override
  _WithNumericSecureKeyboardState createState() => _WithNumericSecureKeyboardState();
}

class _WithNumericSecureKeyboardState extends State<WithNumericSecureKeyboard> {
  final _secureKeyboardStateController = StreamController<bool>.broadcast();

  bool _isVisibleSoftwareKeyboard = false;
  bool _shouldShowSecureKeyboard = false;

  void _onSecureKeyboardStateChanged() async {

    if (widget.controller.isShowing) {
      // Schedule the secure keyboard to open when the software keyboard is closed.
      if (_isVisibleSoftwareKeyboard) {
        _shouldShowSecureKeyboard = true;
      }

      // Hide software keyboard
      FocusScope.of(context).requestFocus(FocusNode());

      // If there is a reservation to open the secure keyboard,
      // do not open the secure keyboard immediately.
      if (!_shouldShowSecureKeyboard) {
        _setSecureKeyboardState(true);
      }
    } else {
      _setSecureKeyboardState(false);
    }
  }

  void _setSecureKeyboardState(bool state) async {

    if (state) {
      // Show secure keyboard
      _secureKeyboardStateController.sink.add(true);

      // Scroll to text field position after duration.
      final focusNode = widget.controller._focusNode;
      if (focusNode == null) return;
      if (focusNode.context == null) return;

      const duration = Duration(milliseconds: 250);
      await Future.delayed(duration);
      Scrollable.ensureVisible(

          focusNode.context!,
          duration: duration,
          alignment: 0.5,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,

      );
    } else {
      // Hide secure keyboard
      _secureKeyboardStateController.sink.add(false);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSecureKeyboardStateChanged);
    KeyboardVisibilityController().onChange.listen((visible) {

      _isVisibleSoftwareKeyboard = visible;

      // Prevents opening at the same time as the software keyboard.
      if (widget.controller.isShowing && visible) {
        widget.controller.hide();
      }

      // Open the secure keyboard when the software keyboard is closed
      // if there is a reservation to open the secure keyboard.
      if (_shouldShowSecureKeyboard && !visible) {
        _setSecureKeyboardState(true);
        _shouldShowSecureKeyboard = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: widget.child),
          _secureKeyboardBuilder()
        ],
      ),
    );
  }
  
  Widget _secureKeyboardBuilder() {
    return StreamBuilder<bool>(
      stream: _secureKeyboardStateController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel()
      ),
      initialData: false,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (snapshot.data == true)
              ? _buildSecureKeyboard()
              : const SizedBox.shrink()
        );
      }
    );
  }
  
  Widget _buildSecureKeyboard() {
    final onKeyPressed = widget.controller._onKeyPressed;
    final onCharCodesChanged = widget.controller._onCharCodesChanged;

    return SecureNumericKeyboard(
      initText: widget.controller._initText,
      obscuringCharacter: widget.controller._obscuringCharacter,
      maxLength: widget.controller._maxLength,
      shuffleNumericKey: widget.controller._shuffleNumericKey,
      keyboardTheme: widget.controller._keyboardTheme ?? KeyboardTheme(),
      screenCaptureDetectedAlertTitle: widget.screenCaptureDetectedAlertTitle,
      screenCaptureDetectedAlertMessage: widget.screenCaptureDetectedAlertMessage,
      screenCaptureDetectedAlertActionTitle: widget.screenCaptureDetectedAlertActionTitle,
      onKeyPressed: onKeyPressed,
      onCharCodesChanged: onCharCodesChanged,
    );
  }


  @override
  void dispose() {
    widget.controller.removeListener(_onSecureKeyboardStateChanged);
    _secureKeyboardStateController.close();
    super.dispose();
  }
}

/// Controller to check or control the state of the secure keyboard.
class SecureKeyboardController extends ChangeNotifier {
  bool _isShowing = false;

  /// Whether the secure keyboard is showing.
  bool get isShowing => _isShowing;

  FocusNode? _focusNode;
  String? _initText;
  late String _obscuringCharacter;
  int? _maxLength;
  late bool _shuffleNumericKey;
  KeyboardTheme? _keyboardTheme;

  ValueChanged<SecureNumericKeyboardKey>? _onKeyPressed;
  ValueChanged<List<int>>? _onCharCodesChanged;

  /// Show secure keyboard.
  void show({
    FocusNode? focusNode,
    String? initText,
    String? inputTextLengthSymbol,
    String obscuringCharacter = '•',
    int? maxLength,
    bool alwaysCaps = false,
    bool obscureText = true,
    bool shuffleNumericKey = true,
    bool hideKeyInputMonitor = false,
    bool disableKeyBubble = false,
    KeyboardTheme? keyboardTheme,
    ValueChanged<SecureNumericKeyboardKey>? onKeyPressed,
    ValueChanged<List<int>>? onCharCodesChanged,
  }) {
    assert(obscuringCharacter.isNotEmpty);

    _focusNode = focusNode;
    _initText = initText;
    _keyboardTheme = keyboardTheme;
    _obscuringCharacter = obscuringCharacter;
    _maxLength = maxLength;
    _shuffleNumericKey = shuffleNumericKey;
    _onKeyPressed = onKeyPressed;
    _onCharCodesChanged = onCharCodesChanged;
    _isShowing = true;
    notifyListeners();
  }

  /// Hide secure keyboard.
  void hide() {
    _focusNode = null;
    _initText = null;
    _maxLength = null;
    _onKeyPressed = null;
    _onCharCodesChanged = null;
    _isShowing = false;
    notifyListeners();
  }
}
