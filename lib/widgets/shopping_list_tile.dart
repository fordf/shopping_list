import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile(
      {super.key, required this.groceryItem, required this.onDeleted});

  final GroceryItem groceryItem;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(groceryItem.id),
      onDismissed: (direction) {
        onDeleted();
      },
      background: Container(
        color: Colors.red[600],
      ),
      child: ListTile(
        leading: Container(
          height: 20,
          width: 20,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: groceryItem.category.color,
          ),
        ),
        title: Text(
          groceryItem.name,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Text(
          groceryItem.quantity.toString(),
          style: theme.textTheme.bodyMedium!.copyWith(),
        ),
      ),
    );
  }
}
