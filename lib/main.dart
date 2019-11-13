import 'package:flutter/material.dart';
import 'button.dart';
import 'login.dart';
import 'device.dart';
import 'common.dart';

void main() => runApp(new MaterialApp(
    title: RunTitle,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: new RunButtons()));

class RunButtons extends StatefulWidget {
  @override
  RunButtonsState createState() => new RunButtonsState();
}

class RunButtonsState extends State<RunButtons> {
  static var _status = Status.init;
  static var _btns = new List<BtnInfo>();

  changeStatus(Status newStatus, {List<BtnInfo> btns}) {
    setState(() {
      _status = newStatus;
      if (btns != null) _btns = btns;
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
          return HomePage(_btns);
        }
        break;
    }
    return null;
  }

  Future<Status> loading() async {
    await getDeviceDetails();
    await settings.read();
    var status = Status.login;
    try {
      if (settings.remember) {
        await request('/list').then((result) {
          status = Status.list;
          _btns = result.btns;
        });
      }
    } catch (e) {}
    return status;
  }

  @override
  void initState() {
    super.initState();
    loading().then((state) => changeStatus(state));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RunTitle),
        actions: _status == Status.list
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    request('/list').then((result) {
                      changeStatus(Status.list, btns: result.btns);
                    }).catchError((e) {
                      alertDialog(context, 'Error: $e');
                    });
                  },
                ),
              ]
            : null,
      ),
      body: showPage(),
//      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<BtnInfo> btns;

  HomePage(this.btns);

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
