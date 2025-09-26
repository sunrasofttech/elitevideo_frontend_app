

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

