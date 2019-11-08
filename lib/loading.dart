import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;

String deviceName;
String deviceID;

getDeviceDetails() async {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  if (Platform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    deviceName = build.model;
    //      deviceVersion = build.version.toString();
    deviceID = build.androidId; //UUID for Android
  } else if (Platform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    deviceName = data.name;
//        deviceVersion = data.systemVersion;
    deviceID = data.identifierForVendor; //UUID for iOS
  }
}
