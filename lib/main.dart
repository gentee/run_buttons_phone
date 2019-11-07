import 'package:flutter/material.dart';
import 'button.dart';
import 'login.dart';
import 'loading.dart';

void main() => runApp(RunButtons());

const RunTitle = 'Run Buttons';

void showMenuSelection(String value) {
/*    if (<String>[_simpleValue1, _simpleValue2, _simpleValue3].contains(value))
      _simpleValue = value;
    showInSnackBar('You selected: $value');*/
  print(value);
}

class RunButtons extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(full: true),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: RunTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginPage(), // HomePage(),
      routes: routes,
      home: Scaffold(
        appBar: AppBar(
          title: Text(RunTitle),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: showMenuSelection,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'Toolbar menu',
                  child: Text('Toolbar menu'),
                ),
                const PopupMenuItem<String>(
                  value: 'Right here',
                  child: Text('Right here'),
                ),
                const PopupMenuItem<String>(
                  value: 'Hooray!',
                  child: Text('Hooray!'),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: loading(),
            builder: (context, snapshot) {
              print("GET ${snapshot.data}");
              if (snapshot.hasData) {
                return LoginPage(); //RRHomePage(full: false); //Text(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.full}) : super(key: key);

  final bool full;
  final List<BtnInfo> btns = [
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
    final listview = ListView.builder(
        itemCount: widget.btns.length,
        itemBuilder: (BuildContext context, int index) {
          return BtnInfoCard(
            item: widget.btns[index],
          );
        });

    return widget.full
        ? Scaffold(
            appBar: AppBar(
              title: Text(RunTitle),
              leading: Icon(Icons.menu),
            ),
            body: listview)
        : listview;
/*    return Scaffold(
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
    );*/
  }
}
