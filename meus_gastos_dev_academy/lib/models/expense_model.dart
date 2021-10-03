class Expense {
  int? id;
  final String name;
  final String category;
  final String value;
  final String date;

  Expense({
    this.id,
    required this.name,
    required this.category,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "name": name,
      "value": value,
      "category": category,
      "date": date,
    });
  }
}
