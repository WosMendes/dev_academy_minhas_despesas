import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  String selectedCategory = 'All';

  changeCategory(String category) {
    if (selectedCategory == 'All') {
      selectedCategory = category;
    } else {
      if (selectedCategory == category) {
        selectedCategory = 'All';
      } else {
        selectedCategory = category;
      }
    }
    notifyListeners();
  }
}
