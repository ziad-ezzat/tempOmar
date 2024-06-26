class DrugApiResponse {
  final String message;
  final List<Drug> drugs;
  final int totalDrugs;

  DrugApiResponse({
    required this.message,
    required this.drugs,
    required this.totalDrugs,
  });

  factory DrugApiResponse.fromJson(Map<String, dynamic> json) {
    final drugs = List<Map<String, dynamic>>.from(json['drugs']);
    return DrugApiResponse(
      message: json['message'],
      drugs: drugs.map((drug) => Drug.fromJson(drug)).toList(),
      totalDrugs: json['totalDrugs'],
    );
  }
}
class Drug {
  final String id;
  final String name;
  final double price;
  final String activeIngredient;
  final String category;

  Drug({
    required this.id,
    required this.name,
    required this.price,
    required this.activeIngredient,
    required this.category,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      activeIngredient: json['activeIngredient'],
      category: json['category'],
    );
  }
}







