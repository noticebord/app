import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceHelpers {
  static Future<String> get deviceName async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo info = await deviceInfo.webBrowserInfo;
      return info.browserName.name.toUpperCase();
    }
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      if (info.brand?.isEmpty ?? true) {
        return "ANDROID DEVICE";
      }

      if(info.device?.isEmpty ?? true) {
        return info.brand!.toUpperCase();
      }

      return "${info.brand} ${info.device}".toUpperCase();
    }
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;

      if(info.name?.isEmpty ?? true) {
        return "IOS DEVICE";
      }
      return info.name!.toUpperCase();
    }
    if (Platform.isLinux) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      return info.prettyName.toUpperCase();
    }
    if (Platform.isMacOS) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
      return info.computerName.toUpperCase();
    }
    if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      return info.computerName.toUpperCase();
    }

    return "Unknown Device";
  }
}
