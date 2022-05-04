import 'package:flutter/material.dart';

class WidgetTextGreeting extends StatelessWidget {
  const WidgetTextGreeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hour = DateTime.now().hour;
    String text = "";
    if (hour > 00 && hour < 12) {
      text = "GOOD MORNING";
    } else if (hour > 12 && hour < 16) {
      text = "GOOD AFTERNOON";
    } else {
      text = "GOOD EVENING";
    }
    return Center(
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
