import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/components/expenses_listview.dart';
import 'package:meus_gastos_dev_academy/databases/expenses_database.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';
import 'package:meus_gastos_dev_academy/providers/category_provider.dart';
import 'package:meus_gastos_dev_academy/screens/new_expense_form_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController filterController = TextEditingController();
  List<Expense> filter = [];

  getExpenses() async {
    final expenses = await ExpensesDatabase.db.getExpenses();
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final databaseProvider = Provider.of<ExpensesDatabase>(context);
    late List<Expense> expenses;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: filterController,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                    hintText: 'Filtrar por nome, categoria ou data (dd/MM)'),
                onChanged: (text) {
                  _createFilter(text, expenses);
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    expenses = snapshot.data as List<Expense>;
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      if (expenses.length == 0) {
                        return Center(
                          child:
                              Text('Você ainda não tem despesas registradas!'),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: buildExpensesListView(expenses, filter,
                                  categoryProvider.selectedCategory),
                            ),
                          ],
                        );
                      }
                    default:
                      return Center(
                        child: Text('Erro desconhecido'),
                      );
                  }
                },
              ),
            ),
            SizedBox(
              height: 45,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Registrar Despesa',
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.add),
              Text('Nova Despesa'),
            ],
          ),
          onPressed: () async {
            _createNewExpenseByForm(context, expenses, databaseProvider);
          },
        ),
      ),
    );
  }

  void _createFilter(String text, List<Expense> expenses) {
    if (filterController.text == '') {
      setState(() {
        filter = [];
      });
    } else {
      text = text.toLowerCase();
      filter = [];
      setState(() {
        filter = expenses.where((expense) {
          return expense.name.toLowerCase().contains(text) ||
              expense.category.toLowerCase().contains(text) ||
              expense.date.toLowerCase().contains(text);
        }).toList();
        print(filter.length);
      });
    }
  }

  void _createNewExpenseByForm(BuildContext context, List<Expense> expenses,
      ExpensesDatabase databaseProvider) {
    filter = [];
    FocusScope.of(context).unfocus();
    Future future = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewExpenseFormPage(
          expenses: expenses,
        ),
      ),
    );
    future.then((value) {
      if (value != null) {
        databaseProvider.addNewExpense(value);
      }
    });
  }
}
