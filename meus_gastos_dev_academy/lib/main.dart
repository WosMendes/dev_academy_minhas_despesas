import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/databases/expenses_database.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpensesDatabase()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: MyExpensesApp(),
    ),
  );
}

class MyExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Gastos',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(
        title: 'Minhas Despesas',
      ),
    );
  }
}
