import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

const RunTitle = 'Run Buttons';
const HelpURL = 'https://github.com/gentee/run_buttons_phone';
const DefaultPort = 1321;

enum Status {
  init,
  login,
  list,
}

class Settings {
  String url;
  String ipaddress;
  String password;
  bool deviceon;
  bool remember;

  Settings() {
    url = '';
    ipaddress = '';
    password = '';
    deviceon = false;
    remember = false;
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'ipaddress': ipaddress,
        'password': remember ? password : '',
        'deviceon': deviceon,
        'remember': remember,
      };

  fromJson(Map<String, dynamic> json) {
    this.url = json['url'];
    this.ipaddress = json['ipaddress'];
    this.password = json['password'] ?? '';
    this.deviceon = json['deviceon'] ?? false;
    this.remember = json['remember'] ?? false;
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('settings');
    if (data != null) this.fromJson(json.decode(data));
  }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("settings", json.encode(this));
  }
}

var settings = new Settings();
var deviceName = '';
var deviceID = '';
var defIcon = '';
var defColor = 0;

class BtnInfo {
  const BtnInfo({this.key, this.title, this.desc, this.color, this.icon});

  final String key;
  final String title;
  final String desc;
  final int color;
  final String icon;

  factory BtnInfo.fromJson(Map<String, dynamic> json) {
    var color = json['color'] ?? defColor;
    if (color < 0x1000000) color += 0xff000000;
    return BtnInfo(
      key: json['key'],
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      color: color,
      icon: json['icon'] ?? defIcon,
    );
  }
}

class Result {
  String version;
  String message;
  bool deviceon;
  List<BtnInfo> btns;

  Result({this.version, this.message, this.deviceon, this.btns});

  factory Result.fromJson(Map<String, dynamic> json) {
    List<BtnInfo> btns;

    defIcon = json['deficon'] ?? 'play_circle_outline';
    defColor = json['defcolor'] ?? 0x006699;

    if (json['btns'] != null) {
      btns = new List<BtnInfo>();
      json['btns'].forEach((item) {
        btns.add(BtnInfo.fromJson(item));
      });
    }
    return Result(
      version: json['version'] ?? '',
      message: json['message'] ?? '',
      deviceon: json['deviceon'] ?? false,
      btns: btns,
    );
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<Result> request(String path, {Map<String, String> pars}) async {
  Result ret;
  var host = settings.url + path;
  var errMessage = '';

  try {
    if (path != '/') {
      var forHash = settings.password;
      if (settings.deviceon) {
        forHash += deviceID;
      }
      path += '?device=$deviceName';
      if (pars != null) {
        pars.forEach((key, item) {
          path += '&$key=$item';
        });
        if (pars['key'] != null) {
          forHash += pars['key'];
        }
      }
      path += '&hash=${generateMd5(forHash)}';
    }
    final response = await http.get(settings.url + path);
    if (response.statusCode == 200) {
      try {
        ret = Result.fromJson(json.decode(response.body));
        if (ret.message.length > 0) {
          errMessage = ret.message;
          throw (ret.message);
        }
      } catch (e) {
        if (errMessage.isEmpty) errMessage = 'Fail response from $host';
      }
    } else if (response.statusCode == 401) {
      errMessage = 'Unauthorized';
    } else {
      errMessage = 'Invalid request to the server';
    }
  } catch (e) {
    if (errMessage.isEmpty) {
      throw 'Cannot connect to $host';
    }
    throw Exception(errMessage);
  }
  if (errMessage.isNotEmpty) throw errMessage;

  return ret;
}

final progress = Container(
  width: 300.0,
  height: 200.0,
  alignment: AlignmentDirectional.center,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 25.0),
        child: new Center(
          child: new Text(
            "Connecting...",
            style: new TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    ],
  ),
);

alertDialog(context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            color: Colors.grey[200],
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(context); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}
