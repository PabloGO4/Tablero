import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';

class ListScreen extends StatelessWidget {
  final int listId; // ID de la lista
  final String listName; // Nombre de la lista

  ListScreen({required this.listId, required this.listName});

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(listName),
      ),
      body: FutureBuilder(
        future: databaseProvider.fetchCards(listId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No hay tarjetas disponibles.'));
          }

          final cards = List<Map<String, dynamic>>.from(snapshot.data as List);

          return ListView.builder(
  itemCount: cards.length,
  itemBuilder: (context, index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(cards[index]['title']),
        subtitle: Text(cards[index]['description'] ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditCardDialog(
                  context,
                  databaseProvider,
                  cards[index]['id'], // ID de la tarjeta
                  cards[index]['title'], // Título actual
                  cards[index]['description'], // Descripción actual
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDeleteCard(context, databaseProvider, cards[index]['id']);
              },
            ),
          ],
        ),
      ),
    );
  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewCard(context, databaseProvider, listId),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewCard(
      BuildContext context, DatabaseProvider provider, int listId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva Tarjeta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Descripción'),
              ),
            ],
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
                if (titleController.text.isNotEmpty) {
                  provider.addCard(
                    titleController.text,
                    descriptionController.text,
                    listId,
                  );
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

  void _confirmDeleteCard(BuildContext context, DatabaseProvider provider, int cardId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Eliminar Tarjeta'),
        content: Text('¿Estás seguro de que deseas eliminar esta tarjeta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el cuadro de diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCard(cardId); // Elimina la tarjeta
              Navigator.pop(context); // Cierra el cuadro de diálogo
            },
            child: Text('Eliminar'),
          ),
        ],
      );
    },
  );
}


  void _showEditCardDialog(
      BuildContext context,
      DatabaseProvider provider,
      int cardId,
      String currentTitle,
      String? currentDescription) {
    final titleController = TextEditingController(text: currentTitle);
    final descriptionController = TextEditingController(text: currentDescription ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tarjeta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Descripción'),
              ),
            ],
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
                if (titleController.text.isNotEmpty) {
                  provider.editCard(
                    cardId,
                    titleController.text,
                    descriptionController.text,
                  ); // Actualiza la tarjeta
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
