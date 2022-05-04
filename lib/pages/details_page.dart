import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/UIs/custom_app_bar.dart';
import 'package:youtube1/UIs/custom_navigation_bar.dart';
import 'package:youtube1/UIs/info_box.dart';
import 'package:youtube1/UIs/widget_cart.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/database.dart';
import 'package:youtube1/funcs.dart';
import 'package:youtube1/pages/order_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      body: body(context),
      resizeToAvoidBottomInset: false,
    );
  }

  body(context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                color: color2,
                leftWidgets: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                ],
                title: item.kind,
                rightWidgets: [
                  WidgetStarIconButton(label: item.label),
                ],
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: color2,
                    image: DecorationImage(
                        fit: BoxFit.fitHeight, image: NetworkImage(item.link)),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: color6,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomDivider(),
                            ),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Here it will write the details of the drink or the food but right now idk what to write so if you read this you know that i hate you ",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ),
                            Text(
                              "\$2.65",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: color5),
                            ),
                            const Divider(thickness: 1),
                            const WidgetInfoBox(label: "Customizations"),
                            const CustomizationItems(
                                leftText: "Size", rightText: "Grande"),
                            const CustomizationItems(
                                leftText: "Add-ins",
                                rightText: "Regular Water"),
                            const CustomizationItems(
                                leftText: "Espresso & Shot Opt."),
                            const CustomizationItems(leftText: "Flavors"),
                            const CustomizationItems(leftText: "Tea"),
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, _) {
                    return WidgetFloatingButton(
                      label: "Add item",
                      onTap: () {
                        List<CartItem> items = ref.read(cartProvider);

                        int index =
                            items.indexWhere((element) => element.item == item);

                        if (index != -1) {
                          ref.read(cartProvider.notifier).update(
                              CartItem(
                                  item: item, count: items[index].count + 1),
                              items[index]);
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .add(CartItem(item: item, count: 1));
                        }
                        Funcs().showSnackBar(context, "Added");
                      },
                    );
                  }),
                  const CustomBottomBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetStarIconButton extends ConsumerWidget {
  const WidgetStarIconButton({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> listOfFaves = ref.watch(favoritesProvider);
    bool isFavorite = listOfFaves.contains(label);
    return IconButton(
      onPressed: () {
        if (isFavorite) {
          Funcs().removeFavorites(context, label, ref);
        } else {
          Funcs().addFavorites(context, label, ref);
        }
      },
      icon: isFavorite
          ? Icon(
              Icons.star,
              color: Colors.amber.shade400,
            )
          : const Icon(Icons.star_border),
    );
  }
}

class CustomizationItems extends StatelessWidget {
  const CustomizationItems({
    Key? key,
    this.leftText = "",
    this.rightText = "",
  }) : super(key: key);
  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(leftText,
                    style: Theme.of(context).textTheme.subtitle1)),
            Text(rightText,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: color3)),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              iconSize: 20,
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              color: color3,
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
          color: color1, borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.home_outlined),
          ),
          Expanded(
            child: Text(
              "Here is your addressal sdösa dşlasçöd aslşç dlşasçdlş",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.black),
            ),
          ),
          SizedBox(
            child: const VerticalDivider(),
            height: MediaQuery.of(context).size.height / 20,
          ),
          WidgetCart(onTap: () {
            Navigator.pop(context, true);
          }),
        ],
      ),
    );
  }
}

class WidgetFloatingButton extends ConsumerWidget {
  const WidgetFloatingButton(
      {Key? key, required this.onTap, required this.label})
      : super(key: key);

  final Function() onTap;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: const BoxDecoration(
            color: color5, borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Text(
          label,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: color2),
        ),
      ),
    );
  }
}
