class GrowthRecord {
  final String date;
  final double weight; // em kg
  final double height; // em metros ou centímetros
  final int ageInMonths;

  GrowthRecord({
    required this.date,
    required this.weight,
    required this.height,
    required this.ageInMonths,
  });

  // Cálculo robusto do IMC (converte automaticamente se digitado em cm ou metros)
  double get imc {
    if (weight <= 0 || height <= 0) return 0;
    
    // Se a altura for maior que 3 (ex: 62 ou 75), assume-se que foi digitada em centímetros e converte para metros
    double heightInMeters = height > 3.0 ? height / 100.0 : height;
    
    if (heightInMeters <= 0) return 0;
    return weight / (heightInMeters * heightInMeters);
  }

  // Classificação do IMC adaptada para bebês
  String get imcClassification {
    final value = imc;
    if (value == 0) return 'Não calculado';
    
    if (value < 12.5) {
      return 'Abaixo do peso (Subpeso)';
    } else if (value >= 12.5 && value <= 18.5) {
      return 'Peso adequado (Eutrofia)';
    } else {
      return 'Acima do peso (Sobrepeso)';
    }
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'weight': weight,
        'height': height,
        'ageInMonths': ageInMonths,
      };

  factory GrowthRecord.fromJson(Map<String, dynamic> json) => GrowthRecord(
        date: json['date'] ?? '',
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        height: (json['height'] as num?)?.toDouble() ?? 0.0,
        ageInMonths: json['ageInMonths'] ?? 0,
      );
}