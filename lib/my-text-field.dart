import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final content;

  MyTextField({this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Text(content, textAlign: TextAlign.left),
      ),
    );
  }
}
