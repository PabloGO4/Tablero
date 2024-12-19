import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class DatabaseProvider with ChangeNotifier {
  Future<void> addBoard(String name) async {
    await DatabaseHelper().insert('boards', {'name': name});
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchBoards() async {
    return await DatabaseHelper().queryAll('boards');
  }
}
