import 'package:flutter/material.dart';

class MyStockHeader extends StatelessWidget {
  final String content;

  MyStockHeader({this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(color: Colors.blue),
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(content,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            )
        )
    );
  }
}
