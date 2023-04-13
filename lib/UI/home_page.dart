// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_test/UI/post_screen.dart';
import 'package:sqflite_test/models/user.dart';
import 'package:sqflite_test/controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> _userList = [];

  final _userDatabaseHelper = UserController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  void _refreshUser() async {
    final data = await _userDatabaseHelper.getListOfUser();
    setState(() {
      _userList = data;
    });
  }

  void _deleteItem(User user) async {
    await _userDatabaseHelper.deleteUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted a user!'),
      ),
    );
    _refreshUser();
  }

  Future<void> _addItem() async {
    await _userDatabaseHelper.createUser(
      User(
        id: await _userDatabaseHelper.getUserIdMax(),
        name: _nameController.text,
        address: _addressController.text,
      ),
    );
    _refreshUser();
  }

  Future<void> _updateItem(int id) async {
    await _userDatabaseHelper.updateUser(
      User(
        id: id,
        name: _nameController.text,
        address: _addressController.text,
      ),
    );
    _refreshUser();
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingUser = _userList.firstWhere(
        (element) => element.id == id,
        orElse: () => User(
          id: -1,
          name: '',
          address: '',
        ),
      );

      _nameController.text = existingUser.name;
      _addressController.text = existingUser.address;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
          15,
          15,
          15,
          MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Address',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                } else {
                  await _updateItem(id);
                }

                _nameController.clear();
                _addressController.clear();

                Navigator.of(context).pop();
              },
              child: Text(
                id == null ? 'Create new' : 'Update',
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(
                    user: _userList[index],
                  ),
                ),
              ),
              title: Text(
                _userList[index].name,
              ),
              subtitle: Text(
                _userList[index].address,
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(children: [
                  IconButton(
                    onPressed: () => _showForm(_userList[index].id),
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(_userList[index]),
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                _showForm(null);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
