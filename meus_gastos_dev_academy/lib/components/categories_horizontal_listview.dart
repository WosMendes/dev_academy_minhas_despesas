import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/controllers/form_controller.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';
import 'package:meus_gastos_dev_academy/providers/category_provider.dart';
import 'package:provider/provider.dart';

Container buildCategoriesHorizontalListView(List<Expense> expenses,
    String selectedCategory, FormController? formController) {
  List<String> categories = [];
  expenses
    ..forEach((element) {
      categories.add(element.category);
    });
  categories = categories.toSet().toList();

  return Container(
    height: 50,
    margin: EdgeInsets.all(8.0),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryProvider = Provider.of<CategoryProvider>(context);
        return categoriesHorizontalListViewItem(categories[index],
            categoryProvider, formController, selectedCategory);
      },
    ),
  );
}

Widget categoriesHorizontalListViewItem(String category,
    dynamic categoryProvider, dynamic formController, String selectedCategory) {
  if (selectedCategory == 'Todos' && formController == null) {
    categoryProvider.selectedCategory = selectedCategory;
  }

  return InkWell(
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: categoryProvider.selectedCategory == category
              ? Colors.lightBlue[500]
              : Colors.lightBlue[100]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: categoryProvider.selectedCategory == category
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      margin: EdgeInsets.all(8),
    ),
    onTap: () {
      formController.changeCategory(category);
      selectedCategory = category;
      categoryProvider.changeCategory(category);
    },
  );
}
