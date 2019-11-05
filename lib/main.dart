import 'package:flutter/material.dart';
import 'button.dart';
import 'login.dart';

void main() => runApp(RunButtons());

const RunTitle = 'Run Buttons';

class RunButtons extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: RunTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // HomePage(),
      routes: routes,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  List<BtnInfo> btns = [
    BtnInfo(key: '1', title: "MyButton", desc: "Desc", color: 0xff673230),
    BtnInfo(key: '2', desc: "Desc 2", title: "MyButton 2", color: 0xff0000),
    BtnInfo(key: '3', desc: "Desc 3", title: "MyButton 2"),
    BtnInfo(
        key: '4',
        desc: "Desc 4 wdnwrdwkdjw djkwdwd",
        title: "Run button",
        color: 0xff0000),
  ];

  static String tag = 'home-page';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RunTitle),
        leading: Icon(Icons.menu),
      ),
      body: ListView.builder(
          itemCount: widget.btns.length,
          itemBuilder: (BuildContext context, int index) {
            return BtnInfoCard(
              item: widget.btns[index],
            );
          }),
    );
  }
}
