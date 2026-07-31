import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // 'menino' ou 'menina'
  Future<String> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('baby_gender') ?? 'menino';
  }

  Future<void> setGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_gender', gender);
  }
}