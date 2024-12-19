import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';

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

          final boards = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: boards.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(boards[index]['name']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => databaseProvider.addBoard('Nuevo Tablero'),
        child: Icon(Icons.add),
      ),
    );
  }
}
