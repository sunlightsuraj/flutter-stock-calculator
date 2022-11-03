
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final hintText;
  final TextEditingController controller;

  MyTextFormField({this.hintText, this.controller });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200]),
            controller: controller,
            keyboardType: TextInputType.number));
  }
}
