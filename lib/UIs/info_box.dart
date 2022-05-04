import 'package:flutter/material.dart';
import 'package:youtube1/colors.dart';

class WidgetInfoBox extends StatelessWidget {
  const WidgetInfoBox({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: const BoxDecoration(
          color: color4, borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Text(
        label,
        style: const TextStyle(color: color3, fontWeight: FontWeight.bold),
      ),
    );
  }
}
