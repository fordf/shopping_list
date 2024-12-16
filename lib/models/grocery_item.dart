import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  GroceryItem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      quantity = json['quantity'],
      category = categories[Categories.values.byName((json['category'] as String).toLowerCase())]!;

  static Map<String, dynamic> toJson(GroceryItem item) =>
      {
        'id': item.id,
        'name': item.name,
        'quantity': item.quantity,
        'category': item.category.title,
      };
}
