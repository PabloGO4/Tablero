import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/database_provider.dart';
import 'screens/home_screen.dart';
import 'screens/board_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DatabaseProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trello Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
