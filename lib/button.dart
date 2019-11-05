import 'package:flutter/material.dart';

class BtnInfo {
  const BtnInfo({this.key, this.title, this.desc, this.color});

  final String key;
  final String title;
  final String desc;
  final int color;
}

class BtnInfoCard extends StatelessWidget {
  const BtnInfoCard({Key key, this.item}) : super(key: key);

  final BtnInfo item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: OutlineButton(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: <Widget>[
            Icon(Icons.lens,
                color: item.color == null
                    ? Colors.grey[400]
                    : Color(0xff000000 + item.color)), // size: 18.0),
            SizedBox(width: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      )),
                  Text(item.desc,
                      style: TextStyle(
                        color: Colors.grey[400],
                      )),
                ]),
          ]),
          onPressed: () {
            // Perform some action
          }),
    );
  }
}
