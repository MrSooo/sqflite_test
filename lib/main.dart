// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqflite_test/UI/home_page.dart';
import 'package:sqflite_test/UI/log_page.dart';
import 'package:sqflite_test/UI/post_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<Widget> _page = [
    const HomePage(),
    const PostListPage(),
    const LogPage()
  ];

  static final List<String> _pageTitle = [
    'Users',
    'Posts',
    'Logs of user',
  ];

  final int _index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: _index,
          //   onTap: (value) {
          //     _index = value;
          //     setState(
          //       () {},
          //     );
          //   },
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       label: 'User',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.receipt),
          //       label: 'Posts',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.document_scanner),
          //       label: 'Logs',
          //     ),
          //   ],
          // ),
          appBar: AppBar(
            title: Text(_pageTitle[_index]),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: 'User',
              ),
              Tab(
                icon: Icon(Icons.receipt),
                text: 'Posts',
              ),
              Tab(
                icon: Icon(Icons.document_scanner),
                text: 'Logs',
              ),
            ]),
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         BaseDatabaseHelper.dropDb();
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text('Deleted'),
            //           ),
            //         );
            //         _refreshUser();
            //       },
            //       icon: const Icon(
            //         Icons.delete,
            //       ))
            // ],
          ),
          body: TabBarView(
            children: _page,
          )),
    );
  }
}
