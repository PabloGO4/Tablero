import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import 'list_screen.dart'; // Importa la pantalla ListScreen

class BoardScreen extends StatelessWidget {
  final int boardId; // ID del tablero.
  final String boardName; // Nombre del tablero.

  BoardScreen({required this.boardId, required this.boardName});

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(boardName),
      ),
      body: FutureBuilder(
        future: databaseProvider.fetchLists(boardId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No hay listas disponibles.'));
          }

          final lists = List<Map<String, dynamic>>.from(snapshot.data as List);

          return ListView.builder(
  itemCount: lists.length,
  itemBuilder: (context, index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(lists[index]['name']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditListDialog(
                  context,
                  databaseProvider,
                  lists[index]['id'], // ID de la lista
                  lists[index]['name'], // Nombre actual de la lista
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDeleteList(context, databaseProvider, lists[index]['id']);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListScreen(
                listId: lists[index]['id'],
                listName: lists[index]['name'],
              ),
            ),
          );
        },
      ),
    );
  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewList(context, databaseProvider, boardId),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewList(
      BuildContext context, DatabaseProvider provider, int boardId) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva Lista'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nombre de la lista'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  provider.addList(controller.text, boardId);
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteList(BuildContext context, DatabaseProvider provider, int listId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Eliminar Lista'),
        content: Text('¿Estás seguro de que deseas eliminar esta lista y todas sus tarjetas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el cuadro de diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteList(listId); // Elimina la lista
              Navigator.pop(context); // Cierra el cuadro de diálogo
            },
            child: Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

  void _showEditListDialog(BuildContext context, DatabaseProvider provider, int listId, String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Lista'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nuevo nombre de la lista'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  provider.editList(listId, controller.text); // Actualiza la lista
                  Navigator.pop(context); // Cierra el cuadro de diálogo
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
