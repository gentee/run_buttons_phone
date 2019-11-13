import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.callback);
  final Function callback;
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController ipController =
      TextEditingController(text: settings.ipaddress);
  final TextEditingController pswController =
      new TextEditingController(text: settings.password);

  void onConnect() {
    String ip = ipController.text.toLowerCase();
    if (ip.isEmpty) {
      alertDialog(context, 'Specify IP-address of the desktop.');
      return;
    }
    settings.password = pswController.text;
    settings.ipaddress = ip;
    if (!ip.startsWith('http')) {
      ip = 'http://' + ip;
    }
    if (ip.split(':').length == 2) {
      ip += ':$DefaultPort';
    }
    settings.url = ip;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: progress,
        );
      },
    );
    request('/').then((result) {
      settings.deviceon = result.deviceon;
      request('/list').then((result) {
        settings.save();
        Navigator.pop(context);
        widget.callback(Status.list, btns: result.btns);
      }).catchError((e) {
        Navigator.pop(context);
        alertDialog(context, 'Error: $e');
      });
    }).catchError((e) {
      Navigator.pop(context);
      alertDialog(context, 'Error: $e');
    });
  }

  @override
  void dispose() {
    ipController.dispose();
    pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ipaddress = TextField(
      controller: ipController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'IP-address of the computer',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      controller: pswController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => onConnect(),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Connect', style: TextStyle(color: Colors.white)),
      ),
    );
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 30.0),
        children: <Widget>[
          Center(
              child: Text(
            'Device ID',
            textScaleFactor: 1.4,
          )),
          SizedBox(height: 8.0),
          Container(
            color: Colors.grey[200],
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              '$deviceID',
              textScaleFactor: 1.4,
            ),
          ),
          SizedBox(height: 24.0),
          ipaddress,
          SizedBox(height: 8.0),
          password,
          SizedBox(height: 6.0),
          SwitchListTile(
            value: settings.remember,
            onChanged: (value) {
              settings.remember = value;
            },
            title: new Text('Remember password'),
          ),
          SizedBox(height: 6.0),
          loginButton,
          SizedBox(height: 8.0),
          Center(child: Hyperlink(HelpURL, 'Documentation')),
        ],
      ),
    );
  }
}

class Hyperlink extends StatelessWidget {
  final String _url;
  final String _text;

  Hyperlink(this._url, this._text);

  _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        _text,
//        style: TextStyle(decoration: TextDecoration.underline),
        style: DefaultTextStyle.of(context).style.apply(
            fontSizeFactor: 1.4,
            decoration: TextDecoration.underline,
            color: Colors.blue),
      ),
      onTap: _launchURL,
    );
  }
}
