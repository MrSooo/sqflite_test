import 'package:flutter/material.dart';
import 'package:sqflite_test/db_helper/log_db_helper.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  List<String> _logList = [];
  final _logdb = LogDatabaseHelper();

  void _refreshLog() async {
    final data = await _logdb.getListOfLog();
    setState(() {
      _logList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshLog();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemBuilder: (context, index) => Text(
            _logList[index],
          ),
          itemCount: _logList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
              width: 200,
              child: Divider(
                height: 5,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
    );
  }
}
