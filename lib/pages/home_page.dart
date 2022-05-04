import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/UIs/custom_app_bar.dart';
import 'package:youtube1/UIs/widget_text_greeting.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/database.dart';
import 'package:youtube1/funcs.dart';
import 'package:youtube1/pages/details_page.dart';
import 'package:youtube1/pages/main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Item? item;
    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(
            title: "  STARBUCKS",
            textAlign: TextAlign.left,
          ),
          const Expanded(
            flex: 1,
            child: WidgetTextGreeting(),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(15),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      AssetImage("assets/photo-1579546929518-9e396f3cc809.jpg"),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: Database().getFaveDrink(
                                "Iced Mocha Cookie Crumble Frappuccino"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              } else {
                                item = snapshot.data as Item;
                                return Image.network(
                                  item!.link,
                                  fit: BoxFit.scaleDown,
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: color6,
                          ),
                          child: Column(
                            children: [
                              widgetSpacer(context),
                              Text(
                                "FAVORITE DRINK",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: color5,
                                        fontWeight: FontWeight.bold),
                              ),
                              widgetSpacer(context),
                              Text(
                                "You want to try the favorite drink of Starbucks?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: color5,
                                        fontWeight: FontWeight.normal),
                              ),
                              widgetSpacer(context),
                              Consumer(builder: (context, ref, _) {
                                return WidgetFloatingButton(
                                    onTap: () {
                                      onClick(ref,context,item);
                                    },
                                    label: "Order");
                              }),
                              widgetSpacer(context),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox widgetSpacer(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 40,
    );
  }

  Future onClick(WidgetRef ref,context,item) async {
    ref.read(pageProvider.notifier).changePage(1);
    await Funcs().navigatorPush(
        context,
        DetailsPage(
          item: item!,
        ));
  }
}
