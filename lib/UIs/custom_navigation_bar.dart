import 'package:flutter/material.dart';
import 'package:youtube1/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    this.items,
    required this.pageIndex,
  }) : super(key: key);

  final List<CBNBitem>? items;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: color1, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items ?? [],
      ),
    );
  }
}

class CBNBitem extends StatelessWidget {
  const CBNBitem({
    Key? key,
    required this.text,
    this.iconData,
    required this.onTap,
    required this.isThisPage,
    this.widget,
  }) : super(key: key);

  final bool isThisPage;
  final String text;
  final IconData? iconData;
  final Widget? widget;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isThisPage,
            child: const CustomDivider(),
          ),
          widget ?? Icon(iconData, size: 30),
          Text(text),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: color3, borderRadius: BorderRadius.all(Radius.circular(16))),
      height: 3,
      width: 20,
    );
  }
}
