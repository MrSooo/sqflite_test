// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_test/models/post.dart';
import 'package:sqflite_test/models/user.dart';
import 'package:sqflite_test/controllers/post_controller.dart';

class PostScreen extends StatefulWidget {
  final User user;
  const PostScreen({super.key, required this.user});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Post> _postList = [];

  final _postDatabaseHelper = PostController();

  final _titleController = TextEditingController();

  Future<void> _addItem() async {
    await _postDatabaseHelper.createPost(
      Post(
        id: await _postDatabaseHelper.getPostIdMax(),
        title: _titleController.text,
        userId: widget.user.id,
      ),
    );
    _refreshPost();
  }

  Future<void> _updateItem(int id) async {
    await _postDatabaseHelper.updatePost(
      Post(
        id: id,
        title: _titleController.text,
        userId: widget.user.id,
      ),
    );
    _refreshPost();
  }

  void _deleteItem(Post post) async {
    await _postDatabaseHelper.deletePost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted a user!'),
      ),
    );
    _refreshPost();
  }

  void _refreshPost() async {
    final data = await _postDatabaseHelper.getListOfPostOfUser(
      widget.user,
    );
    setState(() {
      _postList = data;
    });
  }

  @override
  void initState() {
    super.initState();

    _refreshPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts of of User: ${widget.user.name}')),
      body: Center(
        child: ListView.builder(
          itemCount: _postList.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(
                _postList[index].title,
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(children: [
                  IconButton(
                    onPressed: () => _showForm(_postList[index].id),
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(_postList[index]),
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingPost = _postList.firstWhere(
        (element) => element.id == id,
        orElse: () => Post(
          id: -1,
          title: '',
          userId: -1,
        ),
      );

      _titleController.text = existingPost.title;
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
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Post title',
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

                _titleController.clear();

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
}
