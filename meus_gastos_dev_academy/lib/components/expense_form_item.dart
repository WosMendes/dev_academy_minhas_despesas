import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meus_gastos_dev_academy/components/categories_horizontal_listview.dart';
import 'package:meus_gastos_dev_academy/controllers/form_controller.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';
import 'package:validatorless/validatorless.dart';

Widget expenseFormItem(List<Expense> expenses, Expense? selectedExpense,
    FormController formController, BuildContext context) {
  final formKey = GlobalKey<FormState>();
  if (selectedExpense != null) {
    formController.expenseName.text = selectedExpense.name;
    formController.expenseCategory.text = selectedExpense.category;
    formController.expenseValue.text = selectedExpense.value;
    formController.expenseDate.text = selectedExpense.date;
  }

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 48.0,
              ),
              SizedBox(
                height: 24.0,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: formController.expenseName,
                      validator: Validatorless.required('Nome obrigatório'),
                      decoration: InputDecoration(
                        labelText: 'Insira o nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: formController.expenseValue,
                            validator: Validatorless.multiple([
                              Validatorless.required('O valor é obrigatório'),
                              Validatorless.number('Não é um valor válido')
                            ]),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Insira o preço',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##/##')
                            ],
                            controller: formController.expenseDate,
                            validator:
                                Validatorless.required('Data obrigatória'),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: 'Insira a data',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      controller: formController.expenseCategory,
                      decoration: InputDecoration(
                        labelText: 'Crie uma nova categoria',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: Text('Ou escolha uma das categorias abaixo:'),
                    ),
                    buildCategoriesHorizontalListView(expenses,
                        selectedExpense?.category ?? 'All', formController),
                    SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        elevation: 4,
                        onPressed: () {
                          _validateAndSaveExpense(formKey, selectedExpense,
                              formController, context);
                        },
                        label: Text(
                          'Finalizar Registro',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _validateAndSaveExpense(
    GlobalKey<FormState> formKey,
    Expense? selectedExpense,
    FormController formController,
    BuildContext context) {
  var formValid = formKey.currentState?.validate() ?? false;
  if (formValid) {
    final newExpense = selectedExpense != null
        ? Expense(
            id: selectedExpense.id,
            name: formController.expenseName.text,
            category: formController.expenseCategory.text,
            value: formController.expenseValue.text,
            date: formController.expenseDate.text,
          )
        : Expense(
            name: formController.expenseName.text,
            category: formController.expenseCategory.text,
            value: formController.expenseValue.text,
            date: formController.expenseDate.text,
          );
    Navigator.pop(context, newExpense);
  }
}
