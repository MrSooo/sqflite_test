// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_test/models/post.dart';
import 'package:sqflite_test/controllers/post_controller.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({
    super.key,
  });

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<Post> _postList = [];

  final _postController = PostController();

  final _titleController = TextEditingController();
  final _searchController = TextEditingController();

  Future<void> _updateItem(Post post) async {
    await _postController.updatePost(
      Post(
        id: post.id,
        title: _titleController.text,
        userId: post.userId,
      ),
    );
    _refreshPost();
  }

  void _deleteItem(Post post) async {
    // await _postController.deletePost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted a user!'),
      ),
    );
    _searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    _refreshPost();
  }

  void _refreshPost() async {
    final data = await _postController.getListOfPost();
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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintText: 'Nhập ID cần tìm kiếm'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                      ),
                      onPressed: () async {
                        if (_searchController.text.isNotEmpty) {
                          _postList = await _postController.filterPost(
                            _searchController.text,
                          );
                          setState(() {});
                        } else {
                          _refreshPost();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _postList.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(
                    _postList[index].title,
                  ),
                  subtitle: Text('User post: ${_postList[index].userId}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(children: [
                      IconButton(
                        onPressed: () => _showForm(_postList[index]),
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
          ],
        ),
      ),
    );
  }

  void _showForm(Post post) {
    final existingPost = _postList.firstWhere(
      (element) => element.id == post.id,
      orElse: () => Post(
        id: -1,
        title: '',
        userId: -1,
      ),
    );

    _titleController.text = existingPost.title;

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
                await _updateItem(post);
                _titleController.clear();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
              ),
            )
          ],
        ),
      ),
    );
  }
}
