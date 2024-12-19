import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class DatabaseProvider with ChangeNotifier {
  Future<void> addList(String name, int boardId) async {
    if (name.isEmpty || boardId == null) {
      throw Exception('El nombre o el ID del tablero no son válidos');
    }

    await DatabaseHelper().insert('lists', {
      'name': name,
      'board_id': boardId,
    });

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchLists(int boardId) async {
  if (boardId == null) {
    throw Exception('El ID del tablero no es válido.');
  }

  final results = await DatabaseHelper()
      .queryWithCondition('lists', 'board_id = ?', [boardId]);
  print('fetchLists Results: $results');
  return results;
}

Future<void> editList(int listId, String newName) async {
  if (newName.isEmpty) {
    throw Exception('El nombre de la lista no puede estar vacío.');
  }

  await DatabaseHelper().update(
    'lists',
    {'name': newName},
    'id = ?',
    [listId],
  );

  notifyListeners();
}




  Future<List<Map<String, dynamic>>> fetchBoards() async {
    final results = await DatabaseHelper().queryAll('boards');
    print('Boards fetched: $results');
    return results;
  }

  Future<void> addBoard(String name) async {
    if (name.isEmpty) {
      throw Exception('El nombre del tablero no es válido');
    }

    await DatabaseHelper().insert('boards', {'name': name});
    notifyListeners();
  }

Future<void> editBoard(int boardId, String newName) async {
  if (newName.isEmpty) {
    throw Exception('El nombre del tablero no puede estar vacío.');
  }

  await DatabaseHelper().update(
    'boards',
    {'name': newName},
    'id = ?',
    [boardId],
  );

  notifyListeners();
}



Future<void> addCard(String title, String description, int listId) async {
  if (title.isEmpty || listId == null) {
    throw Exception('El título o el ID de la lista no son válidos.');
  }

  await DatabaseHelper().insert('cards', {
    'title': title,
    'description': description,
    'list_id': listId,
  });

  notifyListeners();
}


Future<void> deleteList(int listId) async {
  final db = await DatabaseHelper().database;

  // Elimina todas las tarjetas asociadas a la lista
  await db.delete('cards', where: 'list_id = ?', whereArgs: [listId]);

  // Elimina la lista
  await db.delete('lists', where: 'id = ?', whereArgs: [listId]);

  notifyListeners();
}



Future<List<Map<String, dynamic>>> fetchCards(int listId) async {
  if (listId == null) {
    throw Exception('El ID de la lista no es válido.');
  }

  final results = await DatabaseHelper()
      .queryWithCondition('cards', 'list_id = ?', [listId]);
  print('fetchCards Results: $results');
  return results;
}


Future<void> deleteCard(int cardId) async {
  await DatabaseHelper().delete(
    'cards',
    'id = ?',
    [cardId],
  );
  notifyListeners();
}



Future<void> editCard(int cardId, String newTitle, String newDescription) async {
  if (newTitle.isEmpty) {
    throw Exception('El título de la tarjeta no puede estar vacío.');
  }

  await DatabaseHelper().update(
    'cards',
    {'title': newTitle, 'description': newDescription},
    'id = ?',
    [cardId],
  );

  notifyListeners();
}




}



