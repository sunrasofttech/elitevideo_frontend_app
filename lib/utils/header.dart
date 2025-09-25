import 'package:elite/utils/storage/storage.dart';

class Header {
  static Map<String, String> get header {
    return {
      'Authorization': 'Bearer ${LocalStorageUtils.getToken}',
      'Content-Type': 'application/json',
    };
  }
}
