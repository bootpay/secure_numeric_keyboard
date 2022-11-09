Secure numeric keyboard to prevent KeyLogger attack and screen capture for web, app.

[![pub package](https://img.shields.io/pub/v/secure_numeric_keyboard.svg)](https://pub.dev/packages/secure_numeric_keyboard)

## Screenshots
| <img src="https://github.com/bootpay/secure_numeric_keyboard/blob/main/example.gif?raw=true" width="200">

## Forked Proejct from flutter_secure_keyboard
This project was forked and developed [flutter_secure_keyboard](https://pub.dev/packages/flutter_secure_keyboard/).


## Getting started

To use this plugin, add `secure_numeric_keyboard` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  secure_numeric_keyboard: ^2.2.2
```

## Examples

```dart

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
          },
        ),
      ],
    );
  }
}

```

## Package

* **WithNumericSecureKeyboard** - A widget that implements a secure keyboard with controller.
* **SecureKeyboardController** - Controller to check or control the state of the secure keyboard.

**Note:** The parameters marked with an asterisk(*) are required.

### WithNumericSecureKeyboard

| Parameter | Description |
|---|---|
| `controller`* | Controller to control the secure keyboard. |
| `child`* | A child widget with a secure keyboard. |
| `stringKeyColor` | The color of the string key(alphanumeric, numeric..). <br> Default value is `const Color(0xFF313131)`. |
| `actionKeyColor` | The color of the action key(shift, backspace, clear..). <br> Default value is `const Color(0xFF222222)`. |
| `doneKeyColor` | The color of the done key. <br> Default value is `const Color(0xFF1C7CDC)`. |
| `activatedKeyColor` | The key color when the shift action key is activated. If the value is null, `doneKeyColor` is used. |
| `keyTextStyle` | The text style of the text inside the keyboard key. <br> Default value is `const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500)`. |
| `screenCaptureDetectedAlertTitle` | Security Alert title, only works on iOS. |
| `screenCaptureDetectedAlertMessage` | Security Alert message, only works on iOS |
| `screenCaptureDetectedAlertActionTitle` | Security Alert actionTitle, only works on iOS. |

### KeyboardTheme

| Parameter | Description |
|---|---|
| `keypadHeight` | The height of the keyboard's content. <br> Default value is `270.0`. |
| `keyboardHeight` | The height of the keyboard. <br> Default value is `300.0`. |
| `keyRadius` | The radius of the keyboard key. <br> Default value is `4.0`. |
| `keySpacing` | The spacing between keyboard keys. <br> Default value is `1.2`. |
| `backgroundColor` | The background color of the keyboard. <br> Default value is `Colors.white`. |
| `keyBackgroundColor` | The background color of the keypad. <br> Default value is `Colors.white`. |
| `showTopShadow` | Set whether to show the upper gradient of the keyboard or not <br> Default value is `false`. |
| `topShadowColor` | The color of the gradient at the top of the keyboard `const Color(0xFFF5F5F5)`. |
 
### SecureKeyboardController
| Function | Description |
|---|---|
| `isShowing` | Whether the secure keyboard is showing. |
| `show` | Show secure keyboard. |
| `hide` | Hide secure keyboard. |

### SecureKeyboardController.show()

| Parameter | Description |
|---|---|
| `type`* | The type of the secure keyboard. |
| `focusNode` | The `FocusNode` that will receive focus on. |
| `initText` | The initial value of the input text. | 
| `inputTextLengthSymbol` | The symbol to use when displaying the input text length. |
| `obscuringCharacter` | The secure character to hide the input text. <br> Default value is `•`. |
| `maxLength` | The maximum length of text that can be entered. |
| `alwaysCaps` | Whether to always display uppercase characters. <br> Default value is `false`. |
| `obscureText` | Whether to hide input text as secure characters. <br> Default value is `true`. |
| `shuffleNumericKey` | Whether to shuffle the position of the numeric keys. <br> Default value is `true`. |
| `hideKeyInputMonitor` | Whether to hide the key input monitor. <br> Default value is `false`. |
| `disableKeyBubble` | Whether to disable the key bubble. <br> Default value is `false`. |
| `keyboardTheme` | You can style the keyboard | 
| `onKeyPressed` | Called when the key is pressed. |
| `onCharCodesChanged` | Called when the character codes changed. |

