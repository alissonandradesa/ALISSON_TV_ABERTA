class MilestoneModel {
  final String ageGroup;
  final String category;
  final String description;
  bool isAchieved;

  MilestoneModel({
    required this.ageGroup,
    required this.category,
    required this.description,
    this.isAchieved = false,
  });

  // Converte para Map/JSON para salvar
  Map<String, dynamic> toJson() => {
        'ageGroup': ageGroup,
        'category': category,
        'description': description,
        'isAchieved': isAchieved,
      };

  // Cria o objeto a partir dos dados salvos
  factory MilestoneModel.fromJson(Map<String, dynamic> json) => MilestoneModel(
        ageGroup: json['ageGroup'],
        category: json['category'],
        description: json['description'],
        isAchieved: json['isAchieved'] ?? false,
      );
}