import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class OrientationHelper {
//   static const MethodChannel _method = MethodChannel('orientation_helper');
//   static const EventChannel _event = EventChannel('orientation_helper/stream');

//   static Future<bool> isAutoRotateOn() async {
//     try {
//       return await _method.invokeMethod('isAutoRotateOn');
//     } catch (_) {
//       return false;
//     }
//   }

//   static Stream<bool> get autoRotateStream {
//     return _event.receiveBroadcastStream().map((event) => event as bool);
//   }
// }

class ToastHelper {
  static const platform = MethodChannel("toast");
  static Future<void> showSuccessToast(String message) async {
    try {
      await platform.invokeMethod("showToast", {"message": message});
    } on PlatformException catch (e) {
      debugPrint("Failed to show toast: ${e.message}");
    }
  }
}
