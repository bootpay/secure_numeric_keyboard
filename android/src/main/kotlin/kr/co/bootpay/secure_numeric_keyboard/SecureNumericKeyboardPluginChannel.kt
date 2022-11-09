package kr.co.bootpay.secure_numeric_keyboard

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger

/** FlutterSecureKeyboardPluginChannel */
interface FlutterSecureKeyboardPluginChannel {
	fun initChannel(messenger: BinaryMessenger)
	fun setActivity(activity: Activity?)
	fun disposeChannel()
}
