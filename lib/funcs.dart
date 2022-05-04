import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube1/colors.dart';
import 'package:youtube1/database.dart';
import 'package:youtube1/pages/order_page.dart';

class Funcs {
  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: color3,
      ),
    );
  }

  void addFavorites(context, String label, WidgetRef ref) {
    if (Database().getFavorites.contains(label)) {
      Funcs().showSnackBar(context, "This is already in your favorites!");
      return;
    }
    ref.read(favoritesProvider.notifier).add(label);
    Funcs().showSnackBar(context, "Added!");
  }

  void removeFavorites(context, String label, WidgetRef ref) {
    if (!Database().getFavorites.contains(label)) {
      Funcs().showSnackBar(context, "This is not in your favorites!");
      return;
    }
    ref.read(favoritesProvider.notifier).remove(label);
    Funcs().showSnackBar(context, "Removed!");
  }

   Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

}
