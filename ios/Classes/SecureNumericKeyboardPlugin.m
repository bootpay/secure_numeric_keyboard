#import "SecureNumericKeyboardPlugin.h"
#if __has_include(<secure_numeric_keyboard/secure_numeric_keyboard-Swift.h>)
#import <secure_numeric_keyboard/secure_numeric_keyboard-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "secure_numeric_keyboard-Swift.h"
#endif

@implementation SecureNumericKeyboardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSecureNumericKeyboardPlugin registerWithRegistrar:registrar];
}
@end
