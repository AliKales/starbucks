import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/UIs/custom_app_bar.dart';
import 'package:youtube1/UIs/widget_cart.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/funcs.dart';
import 'package:youtube1/pages/details_page.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CartItem> items = ref.watch(cartProvider);
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                title: "CART",
                leftWidgets: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.no_sim, color: Colors.transparent),
                  ),
                ],
                rightWidgets: [
                  IconButton(
                    onPressed: () {
                      if (items.isNotEmpty) {
                        ref.read(cartProvider.notifier).removeAll();
                      }
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      CartItem item = items[index];
                      return WidgetContainerCartItem(
                        item: item,
                        items: items,
                        ref: ref,
                        index: index,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: WidgetFloatingButton(
                label: "Payment: ${calculatePrice(items)}",
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  String calculatePrice(List<CartItem> items) {
    double price = 0;
    for (var item in items) {
      price += item.item.price * item.count;
    }
    return "\$$price";
  }
}

class WidgetContainerCartItem extends StatelessWidget {
  const WidgetContainerCartItem({
    Key? key,
    required this.item,
    required this.items,
    required this.ref,
    required this.index,
  }) : super(key: key);

  final CartItem item;
  final List<CartItem> items;
  final WidgetRef ref;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        ref.read(cartProvider.notifier).remove(item);
      },
      child: Container(
        margin: index == items.length - 1
            ? const EdgeInsets.fromLTRB(8, 8, 8, 90)
            : const EdgeInsets.all(8),
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 6,
        decoration: const BoxDecoration(
          color: color4,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: color4,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(item.item.link),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.item.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                //padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ref.read(cartProvider.notifier).update(
                              CartItem(item: item.item, count: item.count + 1),
                              item);
                        },
                        child: const SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(Icons.add),
                              )),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Center(
                        child: Text(
                          item.count.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (item.count != 1) {
                            ref.read(cartProvider.notifier).update(
                                CartItem(
                                    item: item.item, count: item.count - 1),
                                item);
                          } else {
                            Funcs()
                                .showSnackBar(context, "Long Press to remove!");
                          }
                        },
                        child: const SizedBox(
                          width: double.maxFinite,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                Icons.remove,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
