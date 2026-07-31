class BabyModel {
  String name;
  String birthDateString; // Formato "DD/MM/AAAA"
  String gender;          // "Menino" ou "Menina"

  BabyModel({
    required this.name,
    required this.birthDateString,
    required this.gender,
  });

  // Converte para Map/JSON para salvar no SharedPreferences
  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDateString': birthDateString,
        'gender': gender,
      };

  factory BabyModel.fromJson(Map<String, dynamic> json) => BabyModel(
        name: json['name'] ?? 'Meu Bebê',
        birthDateString: json['birthDateString'] ?? '01/01/2026',
        gender: json['gender'] ?? 'Menino',
      );

  // Calcula a idade detalhada (anos, meses e dias)
  String get ageFormatted {
    try {
      parts = birthDateString.split('/');
      if (parts.length != 3) return 'Idade não informada';
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;
      int days = today.day - birthDate.day;

      if (days < 0) {
        months--;
        // Pega os dias do mês anterior para o cálculo correto
        final previousMonth = DateTime(today.year, today.month - 1, 0);
        days += previousMonth.day;
      }

      if (months < 0) {
        years--;
        months += 12;
      }

      if (years > 0) {
        return '$years ano(s) e $months mes(es)';
      } else if (months > 0) {
        return '$months mes(es) e $days dia(s)';
      } else {
        return '$days dia(s)';
      }
    } catch (e) {
      return 'Data inválida';
    }
  }

  // Variável temporária de auxílio para o split
  static List<String> parts = [];
}