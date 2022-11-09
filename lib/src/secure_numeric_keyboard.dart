import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_numeric_keyboard/src/keyboard_theme.dart';

import 'secure_numeric_keyboard_key.dart';
import 'secure_numeric_keyboard_key_action.dart';
import 'secure_numeric_keyboard_key_generator.dart';
import 'secure_numeric_keyboard_key_type.dart';

/// Callback function when the string key touch is started.
typedef StringKeyTouchStartCallback = void Function(
    String keyText, Offset position, BoxConstraints constraints);

/// Callback function when the string key touch is finished.
typedef StringKeyTouchEndCallback = void Function();

/// A widget that implements a secure keyboard.
class SecureNumericKeyboard extends StatefulWidget {
  /// The type of the secure keyboard.

  /// Called when the key is pressed.
  final ValueChanged<SecureNumericKeyboardKey>? onKeyPressed;

  /// Called when the character codes changed.
  final ValueChanged<List<int>>? onCharCodesChanged;


  /// The initial value of the input text.
  final String? initText;

  /// The text of the clear key.
  final String? clearKeyText;

  /// The secure character to hide the input text.
  /// Default value is `•`.
  final String obscuringCharacter;

  /// The maximum length of text that can be entered.
  final int? maxLength;

  /// Whether to hide input text as secure characters.
  /// Default value is `true`.
  final bool obscureText;

  /// Whether to shuffle the position of the numeric keys.
  /// Default value is `true`.
  final bool shuffleNumericKey;

  /// The key color when the shift action key is activated.
  /// If the value is null, `doneKeyColor` is used.
  final Color? activatedKeyColor;

  /// Security Alert title, only works on iOS.
  final String? screenCaptureDetectedAlertTitle;

  /// Security Alert message, only works on iOS.
  final String? screenCaptureDetectedAlertMessage;

  /// Security Alert actionTitle, only works on iOS.
  final String? screenCaptureDetectedAlertActionTitle;

  KeyboardTheme? keyboardTheme = KeyboardTheme();

  int? backspaceEventDelay;

  /// Constructs an instance of [SecureNumericKeyboard].
  SecureNumericKeyboard({
    Key? key,
    this.onKeyPressed,
    this.onCharCodesChanged,
    this.initText,
    // this.hintText,
    // this.inputTextLengthSymbol,
    this.clearKeyText,
    this.obscuringCharacter = '•',
    this.obscureText = true,
    this.maxLength,
    this.shuffleNumericKey = true,
    // this.hideKeyInputMonitor = false,
    this.keyboardTheme,
    this.backspaceEventDelay = 100,
    this.activatedKeyColor,
    this.screenCaptureDetectedAlertTitle,
    this.screenCaptureDetectedAlertMessage,
    this.screenCaptureDetectedAlertActionTitle
  })  : assert(obscuringCharacter.isNotEmpty),
        super(key: key);

  @override
  _SecureNumericKeyboardState createState() => _SecureNumericKeyboardState();
}

class _SecureNumericKeyboardState extends State<SecureNumericKeyboard> {
  final _channel = const MethodChannel('secure_numeric_keyboard');

  final _definedKeyRows = <List<SecureNumericKeyboardKey>>[];
  // final _specialKeyRows = <List<SecureNumericKeyboardKey>>[];

  final _charCodesController = StreamController<List<int>>.broadcast();
  final _charCodes = <int>[];

  Timer? _backspaceEventGenerator;


  void _initStateVariables() {

    _definedKeyRows.clear();
    // _specialKeyRows.clear();
    _charCodes.clear();
    if (widget.initText != null)
      _charCodes.addAll(widget.initText!.codeUnits);

    final keyGenerator = SecureNumericKeyboardKeyGenerator.instance;
    _definedKeyRows.addAll(keyGenerator.getKeypad(widget.shuffleNumericKey));
  }

  void _refreshWidgetState() {
    setState(() {});
  }

  void _notifyCharCodesChanged() {
    _charCodesController.sink.add(_charCodes);
  }

  void _onKeyPressed(SecureNumericKeyboardKey key) {

    if (key.type == SecureNumericKeyboardKeyType.STRING) {
      // The length of `charCodes` cannot exceed `maxLength`.
      final maxLength = widget.maxLength;
      if (maxLength != null && (maxLength <= _charCodes.length)) return;

      // -_- Not good...
      if (key.text == null) return;


      _charCodes.add(key.text!.codeUnits.first);
      _notifyCharCodesChanged();
      if (widget.onCharCodesChanged != null)
        widget.onCharCodesChanged!(_charCodes);
    } else if (key.type == SecureNumericKeyboardKeyType.ACTION) {
      switch (key.action) {
        case SecureNumericKeyboardKeyAction.BACKSPACE:
          if (_charCodes.isNotEmpty) {
            _charCodes.removeLast();
            _notifyCharCodesChanged();
            if (widget.onCharCodesChanged != null)
              widget.onCharCodesChanged!(_charCodes);
          }
          break;
        default:
          return;
      }
    }

    if (widget.onKeyPressed != null)
      widget.onKeyPressed!(key);
  }

  @override
  void didUpdateWidget(covariant SecureNumericKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initStateVariables();
  }

  @override
  void initState() {
    super.initState();
    _channel.invokeMethod('secureModeOn', {
      'screenCaptureDetectedAlertTitle': widget.screenCaptureDetectedAlertTitle,
      'screenCaptureDetectedAlertMessage': widget.screenCaptureDetectedAlertMessage,
      'screenCaptureDetectedAlertActionTitle': widget.screenCaptureDetectedAlertActionTitle
    });
    _initStateVariables();
  }

  @override
  Widget build(BuildContext context) {

    double freeSpace = MediaQuery.of(context).padding.bottom;
    if(freeSpace > 20) {
      freeSpace = 20;
    }

    // double height = (widget.keyboardTheme?.keypadHeight ?? 280) + freeSpace;
    double height = (widget.keyboardTheme?.keyboardHeight ?? 300);


    final keyRows =  _definedKeyRows;

    final keyboard = Padding(
      padding: (widget.keyboardTheme?.keyDefaultPadding ?? EdgeInsets.zero),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildKeyboardKey(keyRows)
      ),
    );

    double keyboardHeight = widget.keyboardTheme?.keyboardHeight ?? 0;
    double keypadHeight = widget.keyboardTheme?.keypadHeight ?? 0;
    double topShadowHeight = max((keyboardHeight - keypadHeight) / 2, 0);
    // if(widget.keyboardTheme?.showTopShadow == false) {
    //   topShadowHeight = 0;
    // }

    final topShadow = Container(
      height: topShadowHeight,
      color: (widget.keyboardTheme?.showTopShadow == false) ? widget.keyboardTheme?.backgroundColor : null,
      decoration: (widget.keyboardTheme?.showTopShadow == false) ? null : BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.keyboardTheme?.topShadowColor ?? const Color(0xFFF5F5F5),
                widget.keyboardTheme?.backgroundColor ?? Colors.white,
              ])
      ),
    );

    return SizedBox(
      height: height,
      child: Column(
        children: [
          topShadow,
          Container(
            width: MediaQuery.of(context).size.width,
            height: height - topShadowHeight,
            color: widget.keyboardTheme?.backgroundColor,
            child: keyboard,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildKeyboardKey(List<List<SecureNumericKeyboardKey>> keyRows) {
    return List.generate(keyRows.length, (int rowNum) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(keyRows[rowNum].length, (int keyNum) {
            final key = keyRows[rowNum][keyNum];

            switch (key.type) {
              case SecureNumericKeyboardKeyType.STRING:
                return _buildStringKey(key, keyRows.length);
              case SecureNumericKeyboardKeyType.ACTION:
                return _buildActionKey(key, keyRows.length);
              default:
                throw Exception('Unknown key type.');
            }
          })
      );
    });
  }

  Widget _buildStringKey(SecureNumericKeyboardKey key, int keyRowsLength) {

    final keyText = key.text ?? '';
    final keyData = Text(keyText, style: widget.keyboardTheme?.textStyle);
    final widgetKey = GlobalKey(debugLabel: 'StringKey');

    return Expanded(
      child: SizedBox(
        key: widgetKey,
        height: ((widget.keyboardTheme?.keypadHeight ?? 270) - 15) / keyRowsLength,
        child: _KeyboardKeyLayout(
          margin: EdgeInsets.all(widget.keyboardTheme?.keySpacing ?? 0),
          borderRadius: BorderRadius.circular(widget.keyboardTheme?.keyRadius ?? 0),
          color: widget.keyboardTheme?.keyBackgroundColor,
          onTouchStart: (constraints) {
          },
          onTouchEnd: (constraints) {
            _onKeyPressed(key);
          },
          child: keyData,
        ),
      ),
    );
  }

  Widget _buildActionKey(SecureNumericKeyboardKey key, int keyRowsLength) {
    Widget keyData;
    switch (key.action ?? SecureNumericKeyboardKeyAction.BLANK) {
      case SecureNumericKeyboardKeyAction.BACKSPACE:
        keyData = Icon(Icons.backspace, color: widget.keyboardTheme?.textStyle?.color);
        break;
      case SecureNumericKeyboardKeyAction.BLANK:
        return const Expanded(child: SizedBox.shrink());
    }

    Color keyColor = widget.keyboardTheme?.keyBackgroundColor ?? Colors.white;

    _KeyboardKeyPressCallback? onLongPressStart;
    _KeyboardKeyPressCallback? onLongPressEnd;
    if (key.action == SecureNumericKeyboardKeyAction.BACKSPACE) {
      onLongPressStart = (constraints) {
        final delay = Duration(milliseconds: widget.backspaceEventDelay ?? 100);
        _backspaceEventGenerator = Timer.periodic(delay, (_) => _onKeyPressed(key));
      };
      onLongPressEnd = (constraints) {
        _backspaceEventGenerator?.cancel();
        _backspaceEventGenerator = null;
      };
    }

    return Expanded(
      child: SizedBox(
        height: (widget.keyboardTheme?.keypadHeight ?? 280) / keyRowsLength,
        child: _KeyboardKeyLayout(
          margin: EdgeInsets.all(widget.keyboardTheme?.keySpacing ?? 0),
          borderRadius: BorderRadius.circular(widget.keyboardTheme?.keyRadius ?? 0),
          color: keyColor,
          onTap: () => _onKeyPressed(key),
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          child: keyData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.invokeMethod('secureModeOff');
    _charCodesController.close();
    super.dispose();
  }
}

typedef _KeyboardKeyPressCallback = void Function(BoxConstraints constraints);

class _KeyboardKeyLayout extends StatefulWidget {
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final GestureTapCallback? onTap;
  final _KeyboardKeyPressCallback? onTouchStart;
  final _KeyboardKeyPressCallback? onTouchEnd;
  final _KeyboardKeyPressCallback? onLongPressStart;
  final _KeyboardKeyPressCallback? onLongPressEnd;
  final Widget child;

  const _KeyboardKeyLayout({
    Key? key,
    this.margin = const EdgeInsets.only(),
    this.borderRadius,
    this.color,
    this.onTap,
    this.onTouchStart,
    this.onTouchEnd,
    this.onLongPressStart,
    this.onLongPressEnd,
    required this.child,
  })  : super(key: key);

  @override
  _KeyboardKeyLayoutState createState() => _KeyboardKeyLayoutState();
}

class _KeyboardKeyLayoutState extends State<_KeyboardKeyLayout> {
  bool _isTapCanceled = false;
  bool _isKeyPressing = false;

  @override
  Widget build(BuildContext context) {
    final keyChild = InkWell(
      onTap: () {
        if (widget.onTap == null) return;
        widget.onTap!();
      },
      onTapCancel: () {
        _isTapCanceled = true;
      },
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius,
        ),
        child: Center(child: widget.child), //no ripple
        // child: Stack(
        //   children: [
        //     Positioned.fill(
        //       child: DecoratedBox(
        //         decoration: BoxDecoration(
        //           color: _isKeyPressing
        //               ? Theme.of(context).splashColor
        //               : Colors.transparent,
        //           borderRadius: widget.borderRadius,
        //         ),
        //       ),
        //     ),
        //     Center(child: widget.child),
        //   ],
        // ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            setState(() {
              _isTapCanceled = false;
              _isKeyPressing = true;
            });

            if (widget.onTouchStart != null) {
              widget.onTouchStart!(constraints);
            }
          },
          onPanCancel: () {
            if (_isTapCanceled && widget.onLongPressEnd != null) return;
            setState(() => _isKeyPressing = false);

            if (widget.onTouchEnd != null) {
              widget.onTouchEnd!(constraints);
            }
          },
          onPanEnd: (_) {
            if (_isTapCanceled && widget.onLongPressEnd != null) return;
            setState(() => _isKeyPressing = false);

            if (widget.onTouchEnd != null) {
              widget.onTouchEnd!(constraints);
            }
          },
          onLongPressStart: widget.onLongPressStart == null ? null : (_) {
            widget.onLongPressStart!(constraints);
          },
          onLongPressEnd: widget.onLongPressEnd == null ? null : (_) {
            setState(() {
              _isTapCanceled = false;
              _isKeyPressing = false;
            });

            widget.onLongPressEnd!(constraints);
            if (widget.onTouchEnd != null) widget.onTouchEnd!(constraints);
          },
          child: keyChild,
        );
      },
    );
  }
}
