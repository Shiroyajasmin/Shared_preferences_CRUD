import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _editController = TextEditingController();
  List<String> itemList = [];
  int editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  void _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      itemList = prefs.getStringList('itemListKey') ?? [];
    });
  }

  void _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('itemListKey', itemList);
  }

  void _addItem() {
    String newItem = _controller.text;
    setState(() {
      itemList.add(newItem);
      _controller.clear();
      _saveList();
    });
  }

  void _editItem(int index) {
    setState(() {
      editingIndex = index;
      _editController.text = itemList[index];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Item'),
            content: TextField(
              controller: _editController,
              decoration: InputDecoration(labelText: 'Edit Item'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    itemList[index] = _editController.text;
                    _editController.clear();
                    editingIndex = -1;
                    _saveList();
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _editController.clear();
                    editingIndex = -1;
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    });
  }

  void _deleteItem(int index) {
    setState(() {
      itemList.removeAt(index);
      _saveList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Preferences Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Add Item'),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      _editItem(index);
                    },
                    icon: Icon(Icons.edit),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      _deleteItem(index);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  title: Text(itemList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
