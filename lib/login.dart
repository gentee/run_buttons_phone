import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'loading.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final ipaddress = TextFormField(
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'IP-address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
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
        onPressed: () {
//          Navigator.of(context).pushNamed(HomePage.tag);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(full: true),
            ),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Connect', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 30.0),
        children: <Widget>[
          Text('Model: $deviceName'),
          Text('Unique ID: $deviceID'),
          ipaddress,
          SizedBox(height: 8.0),
          password,
          SizedBox(height: 24.0),
          loginButton,
          Hyperlink(
              'https://github.com/gentee/run_buttons_phone', 'Documentation'),
          forgotLabel
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
        style: TextStyle(decoration: TextDecoration.underline),
      ),
      onTap: _launchURL,
    );
  }
}
