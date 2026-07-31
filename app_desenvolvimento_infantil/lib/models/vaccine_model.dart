class VaccineModel {
  final String title;
  final String ageRecommendation;
  final String description;
  bool isCompleted;

  VaccineModel({
    required this.title,
    required this.ageRecommendation,
    required this.description,
    this.isCompleted = false,
  });

  // Converte o objeto para JSON para salvar no SharedPreferences
  Map<String, dynamic> toJson() => {
        'title': title,
        'ageRecommendation': ageRecommendation,
        'description': description,
        'isCompleted': isCompleted,
      };

  // Cria um objeto VaccineModel a partir de um JSON salvo
  factory VaccineModel.fromJson(Map<String, dynamic> json) => VaccineModel(
        title: json['title'] ?? '',
        ageRecommendation: json['ageRecommendation'] ?? '',
        description: json['description'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
      );
}