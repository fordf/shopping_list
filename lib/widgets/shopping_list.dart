import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item_form.dart';
import 'package:shopping_list/widgets/shopping_list_tile.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> with SingleTickerProviderStateMixin {
  final List<GroceryItem> groceryList = [];
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _openNewItemForm() async {
    final formResult = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewItemForm(),
      ),
    );

    if (formResult == null) return;
    setState(() {
      groceryList.add(formResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoppinggg!'),
        actions: [
          IconButton(
            onPressed: _openNewItemForm,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: groceryList.isEmpty
          ? SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(
              parent: animationController,
              curve: Curves.decelerate,
            )),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'There\'s ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'nothing',
                            style: TextStyle(
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 239, 59, 119),
                            ),
                          ),
                          TextSpan(text: ' here??!?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        text: 'And you call yourself a ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: 'shopperrr',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 28,
                              color: Color.fromARGB(255, 239, 59, 119),
                            ),
                          ),
                          TextSpan(
                            text: '...',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'wow',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 239, 59, 119),
                      ),
                    ),
                  ],
                ),
              ),
          )
          : ListView.builder(
              itemCount: groceryList.length,
              itemBuilder: (context, index) => ShoppingListTile(
                groceryItem: groceryList[index],
                onDeleted: () {
                  setState(() {
                    groceryList.removeAt(index);
                  });
                },
              ),
            ),
    );
  }
}
