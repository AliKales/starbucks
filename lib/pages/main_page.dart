import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/UIs/custom_navigation_bar.dart';
import 'package:youtube1/UIs/widget_cart.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/pages/cart_page.dart';
import 'package:youtube1/pages/home_page.dart';
import 'package:youtube1/pages/order_page.dart';

class PageNotifier extends StateNotifier<int> {
  PageNotifier() : super(0);

  void changePage(int index) {
    state = index;
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our PageNotifier class.
final pageProvider = StateNotifierProvider<PageNotifier, int>((ref) {
  return PageNotifier();
});

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageProviderRef = ref.watch(pageProvider);
    return Scaffold(
      backgroundColor: color2,
      body: body(pageProviderRef),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavigationBar(
        pageIndex: pageProviderRef,
        items: [
          CBNBitem(
              text: "Home",
              iconData: Icons.home_outlined,
              isThisPage: pageProviderRef == 0,
              onTap: () {
                ref.read(pageProvider.notifier).changePage(0);
              }),
          CBNBitem(
              text: "Order",
              iconData: Icons.local_drink_outlined,
              isThisPage: pageProviderRef == 1,
              onTap: () {
                ref.read(pageProvider.notifier).changePage(1);
              }),
          CBNBitem(
              text: "Cart",
              widget: const WidgetCart(size: 30, isIconButton: false),
              isThisPage: pageProviderRef == 2,
              onTap: () {
                ref.read(pageProvider.notifier).changePage(2);
              }),
        ],
      ),
    );
  }

  body(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const OrderPage();
      case 2:
        return const CartPage();

      default:
        const HomePage();
    }
  }
}
