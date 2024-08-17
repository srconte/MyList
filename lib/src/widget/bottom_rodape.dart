import 'package:flutter/material.dart';
import 'package:myapp/src/stores/text_lista.dart';

class MyHomePages extends StatelessWidget {
  final ValueNotifier<List<TodoItem>> items = ValueNotifier<List<TodoItem>>([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ValueListenableBuilder<List<TodoItem>>(
        valueListenable: items,
        builder: (context, items, _) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editItem(context, items[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem(BuildContext context) {
    _showItemDialog(context);
  }

  void _editItem(BuildContext context, TodoItem item) {
    _showItemDialog(context, item: item);
  }

  void _deleteItem(int index) {
    final updatedItems = List<TodoItem>.from(items.value);
    updatedItems.removeAt(index);
    items.value = updatedItems;
    _saveToRealm();
  }

  void _showItemDialog(BuildContext context, {TodoItem? item}) {
    final TextEditingController controller =
        TextEditingController(text: item?.title ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter item title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (item == null) {
                  _addNewItem(controller.text);
                } else {
                  _updateItem(item, controller.text);
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(String title) {
    final newItem = TodoItem(id: DateTime.now().toString(), title: title);
    final updatedItems = List<TodoItem>.from(items.value)..add(newItem);
    items.value = updatedItems;
    _saveToRealm();
  }

  void _updateItem(TodoItem item, String title) {
    final updatedItems = items.value.map((i) {
      if (i.id == item.id) {
        return TodoItem(id: i.id, title: title);
      }
      return i;
    }).toList();
    items.value = updatedItems;
    _saveToRealm();
  }

  void _saveToRealm() {
    // Implementar a lógica de salvar a lista no Realm aqui
  }

  void _loadFromRealm() {
    // Implementar a lógica de carregar a lista do Realm aqui
  }
}
