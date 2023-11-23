
import 'transak_platform_interface.dart';

class Transak {
  Future<String?> getPlatformVersion() {
    return TransakPlatform.instance.getPlatformVersion();
  }
}
