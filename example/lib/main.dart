import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:secure_numeric_keyboard/secure_numeric_keyboard.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WithNumericSecureKeyboardExample()
    );
  }
}

class WithNumericSecureKeyboardExample extends StatefulWidget {
  @override
  _WithNumericSecureKeyboardExampleState createState() => _WithNumericSecureKeyboardExampleState();
}

class _WithNumericSecureKeyboardExampleState extends State<WithNumericSecureKeyboardExample> {
  final _secureKeyboardController = SecureKeyboardController();

  final _passwordEditor = TextEditingController();
  final _passwordTextFieldFocusNode = FocusNode();

  final _pinCodeEditor = TextEditingController();
  final _pinCodeTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Set the WithNumericSecureKeyboard widget as the top-level widget
    // in the build function so that the secure keyboard works properly.
    return GestureDetector(
      onTap: () {
        _secureKeyboardController.hide();
        FocusScope.of(context).unfocus();
      },
      child: WithNumericSecureKeyboard(
        controller: _secureKeyboardController,
        child: Scaffold(
            appBar: AppBar(title: Text('with_numeric_secure_keyboard_example')),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: _buildContentView()
        ),
      ),
    );
  }

  Widget _buildContentView() {
    // We recommend using the ListView widget to prevent widget overflow.
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        SizedBox(height: 32.0),
        _buildPinCodeTextField(),
        SizedBox(height: 120.0),
        _buildPasswordTextField(),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        TextFormField(
          controller: _passwordEditor,
          focusNode: _passwordTextFieldFocusNode,
          // We recommended to set false to prevent the software keyboard from opening.
          enableInteractiveSelection: false,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          onTap: () {

            _secureKeyboardController.show(
                focusNode: _passwordTextFieldFocusNode,
                initText: _passwordEditor.text,
                keyboardTheme: KeyboardTheme(
                    showTopShadow: true,
                ),
                onCharCodesChanged: (List<int> charCodes) {
                  _passwordEditor.text = String.fromCharCodes(charCodes);
                },
              // on
            );
          },
        ),
      ],
    );
  }

  Widget _buildPinCodeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PinCode'),
        TextFormField(
          controller: _pinCodeEditor,
          focusNode: _pinCodeTextFieldFocusNode,
          // We recommended to set false to prevent the software keyboard from opening.
          enableInteractiveSelection: false,
          // obscureText: true,

          autocorrect: false,
          enableSuggestions: false,
          onTap: () {
            // _secureKeyboardController.show(
            //     focusNode: _pinCodeTextFieldFocusNode,
            //     initText: _pinCodeEditor.text,
            //     keyboardTheme: KeyboardTheme(
            //       showTopShadow: true,
            //     ),
            //     onCharCodesChanged: (List<int> charCodes) {
            //       _pinCodeEditor.text = String.fromCharCodes(charCodes);
            //     },
            // );
          },
        ),
      ],
    );
  }
}
