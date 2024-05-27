import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Categoer extends StatelessWidget {
  Categoer({this.text, this.color, this.OnTap});
  String? text;
  Color? color;
  Function()? OnTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff0D47A1),
            borderRadius:
                BorderRadius.circular(20), // تعيين قيمة الـ border radius هنا
          ),
          child: Center(
            child: Text(
              text!,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
