import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import 'board_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tableros')),
      body: FutureBuilder(
        future: databaseProvider.fetchBoards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No hay tableros disponibles.'));
          }

          final boards = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(boards[index]['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditBoardDialog(
                          context,
                          databaseProvider,
                          boards[index]['id'], // ID del tablero
                          boards[index]['name'], // Nombre actual del tablero
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardScreen(
                        boardId: boards[index]['id'],
                        boardName: boards[index]['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewBoard(context, databaseProvider),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewBoard(BuildContext context, DatabaseProvider provider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nuevo Tablero'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nombre del tablero'),
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
                  provider.addBoard(controller.text);
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

  void _showEditBoardDialog(BuildContext context, DatabaseProvider provider, int boardId, String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tablero'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nuevo nombre del tablero'),
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
                  provider.editBoard(boardId, controller.text); // Edita el tablero
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
