import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/UIs/custom_app_bar.dart';
import 'package:youtube1/UIs/custom_navigation_bar.dart';
import 'package:youtube1/UIs/info_box.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/database.dart';
import 'package:youtube1/funcs.dart';
import 'package:youtube1/pages/details_page.dart';
import 'package:youtube1/pages/main_page.dart';

final drinksProvider =
    FutureProvider<List<Item>>((ref) async => Database().getDrinks());
final foodsProvider =
    FutureProvider<List<Item>>((ref) async => Database().getFoods());

class WhichItemNotifier extends StateNotifier<bool> {
  WhichItemNotifier() : super(true);

  void change() {
    state = !state;
  }
}

final whichItemsProvider = StateNotifierProvider<WhichItemNotifier, bool>(
    (ref) => WhichItemNotifier());

/////

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(Database().getFavorites);

  void add(String label) {
    Database().addFavorite(label);
    state = [...state, label];
  }

  void remove(String label) {
    Database().removeFavorite(label);
    state = state.where((element) => element != label).toList();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>(
        (ref) => FavoritesNotifier());

class OrderPage extends ConsumerWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAllProducts = ref.watch(whichItemsProvider);
    List<String> listOfFaves = ref.watch(favoritesProvider);
    String searchText = ref.watch(searchTextProvider);
    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(
            isSearch: true,
            title: "ORDER",
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.maxFinite,
              child: InkWell(
                onTap: () {
                  ref.read(whichItemsProvider.notifier).change();
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                  decoration: const BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isAllProducts ? color3 : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                          ),
                          child: const Center(
                            child: Text("All products"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isAllProducts ? color3 : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                          ),
                          child: const Center(
                            child: Text("Favorite"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ref.watch(drinksProvider).when(
                  data: (item) => WidgetItems(
                      label: "DRINKS",
                      onDoubleTap: (value) {
                        Funcs().addFavorites(context, value, ref);
                      },
                      onLongPress: (value) {
                        Funcs().removeFavorites(context, value, ref);
                      },
                      items: sortItems(
                          items: item,
                          isAllProducts: isAllProducts,
                          searchText: searchText,
                          listOfFaves: listOfFaves),
                      isAllProducts: isAllProducts),
                  error: (_, __) => const Text("ERROR!"),
                  loading: () => SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 4,
                      child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CircularProgressIndicator())),
                ),
          ),
          const Divider(thickness: 2),
          Expanded(
            flex: 3,
            child: ref.watch(foodsProvider).when(
                  data: (item) => WidgetItems(
                      label: "FOODS",
                      onLongPress: (value) {
                        Funcs().removeFavorites(context, value, ref);
                      },
                      onDoubleTap: (value) {
                        Funcs().addFavorites(context, value, ref);
                      },
                      items: sortItems(
                          items: item,
                          isAllProducts: isAllProducts,
                          searchText: searchText,
                          listOfFaves: listOfFaves),
                      isAllProducts: isAllProducts),
                  error: (_, __) => const Text("ERROR!"),
                  loading: () => SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 4,
                      child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CircularProgressIndicator())),
                ),
          ),
        ],
      ),
    );
  }

  List<Item> sortItems({
    required List<Item> items,
    required bool isAllProducts,
    required String searchText,
    required List listOfFaves,
  }) {
    List<Item> listToReturn = items;
    if (!isAllProducts) {
      listToReturn = listToReturn
          .where((element) => listOfFaves.contains(element.label))
          .toList();
    }
    if (searchText != "") {
      listToReturn = listToReturn
          .where((element) => element.label
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(searchText.replaceAll(" ", "").toLowerCase()))
          .toList();
    }
    return listToReturn;
  }
}

class WidgetItems extends StatelessWidget {
  const WidgetItems({
    Key? key,
    required this.label,
    required this.items,
    required this.isAllProducts,
    required this.onDoubleTap,
    required this.onLongPress,
  }) : super(key: key);

  final Function(String) onDoubleTap;
  final Function(String) onLongPress;
  final String label;
  final List<Item> items;
  final bool isAllProducts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetInfoBox(label: label),
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Consumer(builder: (context, ref, _) {
                  return InkWell(
                    onTap: () async {
                      bool? result = await Funcs().navigatorPush(
                          context,
                          DetailsPage(
                            item: items[index],
                          ));
                      if (result ?? false) {
                        ref.read(pageProvider.notifier).changePage(2);
                      }
                    },
                    onDoubleTap: () {
                      onDoubleTap.call(items[index].label);
                    },
                    onLongPress: () {
                      onLongPress.call(items[index].label);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: const BoxDecoration(
                          color: color4,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: color3,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(items[index].link)),
                              ),
                            ),
                          ),
                          const CustomDivider(),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: Text(
                                  items[index].label,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
