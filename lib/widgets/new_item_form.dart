import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItemForm extends StatefulWidget {
  const NewItemForm({super.key});

  @override
  State<NewItemForm> createState() => _NewItemFormState();
}

class _NewItemFormState extends State<NewItemForm> {
  late String _name;
  late int _quantity;
  Category? _category;
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController(text: "1");

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void submitForm() {
    final formState = formKey.currentState!;
    if (formState.validate()) {
      formState.save();
      final newGroceryItem = GroceryItem(
        id: UniqueKey().toString(),
        name: _name,
        quantity: _quantity,
        category: _category!,
      );
      Navigator.pop(context, newGroceryItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Shopping Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name required.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      controller: quantityController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () {
                        quantityController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: quantityController.value.text.length,
                        );
                      },
                      validator: (value) {
                        final quantity = int.tryParse(value ?? "");
                        if (quantity == null || quantity < 1) {
                          return "Invalid quantity.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _category,
                      hint: const Text('Choose Category'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: [
                        for (final category in categories.values)
                          DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (category) {
                        setState(() {
                          _category = category;
                        });
                      },
                      validator: (value) {
                        if (value == null) return "Category required.";
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      formKey.currentState!.reset();
                      _category = null;
                    },
                    child: const Text('Reset'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: submitForm,
                    child: const Text('Add item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
