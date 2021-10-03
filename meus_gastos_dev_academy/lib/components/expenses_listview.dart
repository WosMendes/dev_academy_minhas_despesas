import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/databases/expenses_database.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';
import 'package:meus_gastos_dev_academy/providers/category_provider.dart';
import 'package:meus_gastos_dev_academy/screens/edit_expense_form_page.dart';
import 'package:provider/provider.dart';

Container buildExpensesListView(
    List<Expense> expenses, List<Expense> filterList, String selectedCategory) {
  final bool isListComplete = filterList.isEmpty ? true : false;

  return Container(
    margin: EdgeInsets.all(8.0),
    child: ListView.builder(
      itemCount: isListComplete ? expenses.length : filterList.length,
      itemBuilder: (context, index) {
        return isListComplete
            ? expensesListViewItem(expenses, index, context, selectedCategory,
                isListComplete, null)
            : expensesListViewItem(filterList, index, context, selectedCategory,
                isListComplete, expenses);
      },
    ),
  );
}

Widget expensesListViewItem(
    List<Expense> expenses,
    int index,
    BuildContext context,
    String selectedCategory,
    bool isListComplete,
    List<Expense>? completeList) {
  final databaseProvider = Provider.of<ExpensesDatabase>(context);
  return Column(
    children: [
      Card(
        elevation: 3,
        child: ListTile(
          leading: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                expenses[index].value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.shopping_bag_outlined)
            ],
          ),
          title: Text(expenses[index].name),
          subtitle: Row(
            children: [
              Text(expenses[index].category),
            ],
          ),
          trailing: Text(expenses[index].date),
          onTap: () async {
            Future future = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditExpenseFormPage(
                  expenses: isListComplete ? expenses : completeList!,
                  expense: expenses[index],
                ),
              ),
            );
            future.then((value) {
              if (value != null) {
                databaseProvider.updateExpense(value);
                Provider.of<CategoryProvider>(context).selectedCategory = 'All';
              }
            });
          },
          onLongPress: () {
            if (isListComplete) {
              _removeExpense(context, expenses, index, databaseProvider);
            }
          },
        ),
      ),
      SizedBox(
        height: 12,
      )
    ],
  );
}

void _removeExpense(BuildContext context, List<Expense> expenses, int index,
    ExpensesDatabase databaseProvider) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Deseja remover ${expenses[index].name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  databaseProvider.removeExpense(expenses[index].id);
                  Navigator.pop(context);
                },
                child: Text('Remover'),
              ),
            ],
          ));
}
