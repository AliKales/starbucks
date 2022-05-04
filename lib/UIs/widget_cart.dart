import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/database.dart';

class CartItem {
  final Item item;
  final int count;

  CartItem({required this.item, required this.count});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void add(CartItem item) {
    state = [...state, item];
  }

  void remove(CartItem item) {
    state = state.where((element) => element != item).toList();
  }

  void update(CartItem itemToAdd, CartItem itemToDelete) {
    int index =
        state.indexWhere((element) => element.item == itemToDelete.item);
    state[index] = itemToAdd;
    state = state.toList();
  }

  void removeAll() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
    (ref) => CartNotifier());

class WidgetCart extends ConsumerWidget {
  const WidgetCart({
    Key? key,
    this.size = 24,
    this.isIconButton = true,
    this.onTap,
  }) : super(key: key);

  final double size;
  final bool isIconButton;
  final Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CartItem> items = ref.watch(cartProvider);
    if (!isIconButton) {
      return WidgetWithNumber(
        num: items.length,
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: size,
          ),
        ),
      );
    }
    return WidgetWithNumber(
      widget: IconButton(
        onPressed: () {
          onTap?.call();
        },
        iconSize: size,
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
      num: items.length,
    );
  }
}

class WidgetWithNumber extends StatelessWidget {
  const WidgetWithNumber({Key? key, required this.widget, required this.num})
      : super(key: key);
  final Widget widget;
  final int num;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: Text(
                num.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
