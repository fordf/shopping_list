import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_data.dart';
import 'package:shopping_list/widgets/shopping_list_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shoppinggg!'),
        ),
        body: ListView(
          children: [
            for (final groceryItem in groceryItems)
              ShoppingListTile(groceryItem: groceryItem)
          ],
        ),
      ),
    );
  }
}
