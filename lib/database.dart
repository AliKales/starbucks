//final databaseProvider = Provider((ref) => Database());

class Database {
  static List<String> favorites = [
    "Chai Latte",
  ];

  List<String> get getFavorites => favorites;

  List<Item> items = const [
    Item(Type.drink,
        label: "Chai Latte",
        link:
            "https://www.morpencere.com/wp-content/uploads/2020/06/img_5efaf649d5d7e.png"),
    Item(Type.drink,
        label: "Iced White Chocolate Mocha",
        link:
            "https://globalassets.starbucks.com/assets/b80d893714854b5c946ee6c7f0d369d7.jpg?impolicy=1by1_wide_topcrop_630"),
    Item(Type.drink,
        label: "Iced Caffè Mocha",
        link:
            "https://globalassets.starbucks.com/assets/0360378c6e774cc3a38d870fc75d5462.jpg?impolicy=1by1_wide_topcrop_630"),
    Item(Type.drink,
        label: "Iced Mocha Cookie Crumble Frappuccino",
        kind: "Cold Drinks",
        link:
            "https://www.pngall.com/wp-content/uploads/4/Starbucks-Coffee.png"),
    Item(Type.food,
        label: "Chocolate Chunk Cookie",
        link:
            "https://www.digitalassets.starbucks.eu/sites/starbucks-medialibrary/files/assets/25c5f09df8203ce9a8b61c314576b491.jpg"),
    Item(Type.food,
        label: "Double Chocolate Brownie",
        link:
            "https://globalassets.starbucks.com/assets/f827715797044a78bb79b86728a079cf.jpg?impolicy=1by1_medium_630"),
    Item(Type.food,
        label: "Brownie Slice",
        link:
            "https://www.starbucks.com.au/imagecache/bestfit/750x750/_files/food-menu-photos/OnlineMenu_FoodTile_22.jpg"),
  ];

  Future<List<Item>> getFoods() async {
    await Future.delayed(const Duration(seconds: 2));
    List<Item> returnn = [];
    for (var item in items) {
      if (item.type == Type.food) returnn.add(item);
    }
    return returnn;
  }

  Future<List<Item>> getDrinks() async {
    await Future.delayed(const Duration(seconds: 2));
    List<Item> returnn = [];
    for (var item in items) {
      if (item.type == Type.drink) returnn.add(item);
    }
    return returnn;
  }

  Future<Item> getFaveDrink(String name) async {
    await Future.delayed(const Duration(seconds: 2));
    return items.firstWhere((element) => element.label==name);
  }

  void addFavorite(String label) {
    favorites.add(label);
  }

  void removeFavorite(String label) {
    favorites.removeWhere((element) => element == label);
  }
}

class Item {
  const Item(this.type,
      {required this.label,
      required this.link,
      this.kind = "",
      this.price = 3.8});

  final String label;
  final String link;
  final String kind;
  final Type type;
  final double price;
}

enum Type {
  food,
  drink,
}
