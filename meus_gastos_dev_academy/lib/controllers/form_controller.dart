import 'package:flutter/material.dart';

class FormController {
  final TextEditingController expenseName = TextEditingController();
  final TextEditingController expenseValue = TextEditingController();
  final TextEditingController expenseDate = TextEditingController();
  final TextEditingController expenseCategory = TextEditingController();

  changeCategory(String category) {
    if (expenseCategory.text == category) {
      expenseCategory.text = '';
    } else {
      expenseCategory.text = category;
    }
  }
}
