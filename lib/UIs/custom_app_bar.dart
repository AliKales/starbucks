import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/colors.dart';

class SearchingNotifier extends StateNotifier<bool> {
  SearchingNotifier() : super(false);

  void change() {
    state = !state;
  }
}

final searchingProvider =
    StateNotifierProvider.autoDispose<SearchingNotifier, bool>(
        (ref) => SearchingNotifier());

final searchTextProvider = StateProvider<String>(
  // We return the default sort type, here name.
  (ref) => "",
);

TextEditingController tECSearch = TextEditingController();

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key? key,
      this.title,
      this.rightWidgets,
      this.leftWidgets,
      this.isSearch = false,
      this.color = color1,
      this.textAlign = TextAlign.center})
      : super(key: key);

  final String? title;
  final List<Widget>? rightWidgets;
  final List? leftWidgets;
  final bool isSearch;
  final Color color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    if (isSearch) {
      return Consumer(
        builder: (context, ref, child) {
          bool searching = ref.watch(searchingProvider);
          return Container(
            color: color,
            width: double.maxFinite,
            child: Row(
              children: [
                ...leftWidgets ??
                    [
                      widgetEmptyIcon(),
                    ],
                Expanded(
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Visibility(
                  visible: searching,
                  child: Expanded(
                      child: TextField(
                    controller: tECSearch,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  )),
                ),
                IconButton(
                  onPressed: () {
                    if (tECSearch.text.trim() == "") {
                      if (searching) {
                        ref.read(searchTextProvider.notifier).state = "";
                      }
                      ref.read(searchingProvider.notifier).change();
                    } else {
                      ref.read(searchTextProvider.notifier).state =
                          tECSearch.text.trim();
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      color: color,
      width: double.maxFinite,
      child: Row(
        children: [
          Row(
            children: [
              ...leftWidgets ??
                  [
                    if (textAlign == TextAlign.center) widgetEmptyIcon(),
                  ]
            ],
          ),
          Expanded(
            child: Text(
              title ?? "",
              textAlign: textAlign,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              ...rightWidgets ??
                  [
                    widgetEmptyIcon(),
                  ]
            ],
          ),
        ],
      ),
    );
  }

  Widget widgetEmptyIcon() {
    return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search, color: Colors.transparent));
  }
}
