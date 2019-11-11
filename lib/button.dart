import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'common.dart';

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
            Icon(
                getMaterialIcon(name: item.icon) ??
                    getMaterialIcon(name: defIcon),
                size: 36.0,
                color:
                    item.color == null ? Colors.grey[400] : Color(item.color)),
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
            request('/run', pars: {'key': item.key})
                .then((result) {})
                .catchError((e) {
              alertDialog(context, 'Error: $e');
            });
            // Perform some action
          }),
    );
  }
}
