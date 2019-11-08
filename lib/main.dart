import 'package:flutter/material.dart';
import 'button.dart';
import 'login.dart';
import 'loading.dart';
import 'common.dart';

void main() => runApp(RunButtons());

class RunButtons extends StatefulWidget {
  @override
  RunButtonsState createState() => new RunButtonsState();
}

class RunButtonsState extends State<RunButtons> {
  static var _status = Status.init;

  changeStatus(Status newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  Widget showPage() {
    switch (_status) {
      case Status.init:
        {
          return Center(child: CircularProgressIndicator());
        }
        break;
      case Status.login:
        {
          return LoginPage(changeStatus);
        }
        break;
      case Status.list:
        {
          return HomePage();
        }
        break;
    }
    return null;
  }

  Future<Status> loading() async {
    await new Future.delayed(const Duration(seconds: 3), () {});
    await getDeviceDetails();
    return Status.login;
  }

  @override
  void initState() {
    super.initState();
    loading().then((state) => changeStatus(state));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: RunTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(RunTitle),
          actions: _status == Status.list ? <Widget>[] : null,
        ),
        body: showPage(),
      ),
    );
  }
}

/*
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
*/

class HomePage extends StatefulWidget {
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
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.btns.length,
        itemBuilder: (BuildContext context, int index) {
          return BtnInfoCard(
            item: widget.btns[index],
          );
        });
  }
}
