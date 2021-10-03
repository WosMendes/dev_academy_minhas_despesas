import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/components/expense_form_item.dart';
import 'package:meus_gastos_dev_academy/controllers/form_controller.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';

class NewExpenseFormPage extends StatefulWidget {
  final List<Expense> expenses;

  NewExpenseFormPage({Key? key, required this.expenses}) : super(key: key);

  @override
  _NewExpenseFormPageState createState() => _NewExpenseFormPageState();
}

class _NewExpenseFormPageState extends State<NewExpenseFormPage> {
  final formController = FormController();

  @override
  void dispose() {
    formController.expenseName.dispose();
    formController.expenseCategory.dispose();
    formController.expenseDate.dispose();
    formController.expenseValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nova Despesa',
        ),
      ),
      body: expenseFormItem(widget.expenses, null, formController, context),
    );
  }
}
