import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/main.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/list_placeholder.dart';
import 'package:shopping_list/widgets/new_item_form.dart';
import 'package:shopping_list/widgets/shopping_list_tile.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<GroceryItem> groceryList = [];
  bool isLoading = true;
  bool canTryAgain = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  Future<T1> waitConcurrently<T1, T2>(
    Future<T1> future1,
    Future<T2> future2,
  ) async {
    late T1 result1;

    await Future.wait([future1.then((value) => result1 = value), future2]);

    return result1;
  }

  void fetchList() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.https(kRestUrl, 'shopping-list.json');
    try {
      final request = http.get(url);
      final response = await waitConcurrently(
        request,
        Future.delayed(
          const Duration(seconds: 1),
        ),
      );
      setState(() {
        isLoading = false;
      });
      if (response.statusCode != 200) {
        throw HttpException(response.statusCode.toString());
      } else {
        if (response.body == 'null') return;
        final Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          groceryList.addAll(responseBody.entries.map((itemMap) {
            final Map<String, dynamic> groceryItemJson = {
              'id': itemMap.key,
              ...itemMap.value
            };
            return GroceryItem.fromJson(groceryItemJson);
          }));
        });
      }
    } on SocketException {
      _onFetchError('No Internet connection 😑');
    } on HttpException {
      _onFetchError("Couldn't find the post 😱");
    } on FormatException {
      _onFetchError("Bad response format 👎");
    }
  }

  void _onFetchError(text) {
    if (!context.mounted) return;
    setState(() {
      errorText = text;
      isLoading = false;
      canTryAgain = true;
    });
    _showErrorSnackBar('Failed to fetch shopping list...');
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

  void _deleteItemAtIndex(int index) async {
    final id = groceryList[index].id;
    final url = Uri.https(kRestUrl, 'shopping-list/$id.json');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      if (!context.mounted) return;
      _showErrorSnackBar('Failed to delete item...');
    } else {
      setState(() {
        groceryList.removeAt(index);
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : canTryAgain
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorText!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchList,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : groceryList.isEmpty
                  ? const ListPlaceholder()
                  : ListView.builder(
                      itemCount: groceryList.length,
                      itemBuilder: (context, index) => ShoppingListTile(
                        groceryItem: groceryList[index],
                        onDeleted: () {
                          _deleteItemAtIndex(index);
                        },
                      ),
                    ),
    );
  }
}
