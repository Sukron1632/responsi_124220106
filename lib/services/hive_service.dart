import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:responsi/models/amiibo_model.dart';
import 'package:responsi/models/user_model.dart';

class HiveService {
  static const String _usersBoxName = 'users';
  static const String _favoritesBoxName = 'favorites';

  // Fungsi inisialisasi Hive
  static Future<void> init() async {
    try {
      await Hive.initFlutter();  // Inisialisasi Hive
      _registerAdapters();  // Pendaftaran adapter
      await _openBoxes();  // Membuka semua box yang diperlukan
    } catch (e) {
      debugPrint('Hive initialization error: $e');
      rethrow;
    }
  }

  // Menyimpan data user ke Hive
  static Future<void> saveUser(User user) async {
    try {
      final userBox = await Hive.openBox<User>(_usersBoxName);
      await userBox.put(user.username, user);
      debugPrint('User ${user.username} saved');
    } catch (e) {
      debugPrint('Error saving user: $e');
      rethrow;
    }
  }

  // Mendapatkan data user berdasarkan username
  static User? getUser(String username) {
    try {
      final userBox = Hive.box<User>(_usersBoxName);
      return userBox.get(username);
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // Validasi user
  static bool validateUser(String username, String password) {
    try {
      final user = getUser(username);
      return user != null && user.password == password;
    } catch (e) {
      debugPrint('Error validating user: $e');
      return false;
    }
  }

  // Mengecek apakah username sudah ada
  static bool isUsernameTaken(String username) {
    try {
      final userBox = Hive.box<User>(_usersBoxName);
      return userBox.containsKey(username);
    } catch (e) {
      debugPrint('Error checking username: $e');
      return false;
    }
  }

  // Mendaftarkan Adapter
  static void _registerAdapters() {
    // Pendaftaran adapter hanya jika belum terdaftar
    if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
      Hive.registerAdapter(UserAdapter());
      debugPrint('UserAdapter registered');
    }

    if (!Hive.isAdapterRegistered(AmiiboModelAdapter().typeId)) {
      Hive.registerAdapter(AmiiboModelAdapter());
      debugPrint('AmiiboModelAdapter registered');
    }
  }

  // Membuka box-box yang diperlukan
  static Future<void> _openBoxes() async {
    try {
      // Membuka box untuk User dan AmiiboModel jika belum terbuka
      if (!Hive.isBoxOpen(_usersBoxName)) {
        await Hive.openBox<User>(_usersBoxName);
        debugPrint('User box opened');
      }
      if (!Hive.isBoxOpen(_favoritesBoxName)) {
        await Hive.openBox<AmiiboModel>(_favoritesBoxName);
        debugPrint('Favorites box opened');
      }
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
      rethrow;
    }
  }

  // Menyimpan AmiiboModel ke favorit
  static Future<void> saveFavorite(AmiiboModel amiibo) async {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);

      // Memastikan amiibo belum ada di favorit
      if (!favBox.values.any((existingAmiibo) => existingAmiibo.id == amiibo.id)) {
        await favBox.put(amiibo.id, amiibo);
        debugPrint('Amiibo ${amiibo.name} saved to favorites');
      }
    } catch (e) {
      debugPrint('Error saving favorite: $e');
      rethrow;
    }
  }

  // Menghapus AmiiboModel dari favorit
  static Future<void> removeFavorite(AmiiboModel amiibo) async {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      await favBox.delete(amiibo.id);
      debugPrint('Amiibo ${amiibo.name} removed from favorites');
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  // Mendapatkan semua data favorit
  static List<AmiiboModel> getFavorites() {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      return favBox.values.toList();
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  // Mengecek apakah AmiiboModel ada di favorit
  static bool isFavorite(AmiiboModel amiibo) {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      return favBox.containsKey(amiibo.id);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

  // Menghapus semua data favorit
  static Future<void> clearFavorites() async {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      await favBox.clear();
      debugPrint('All favorites cleared');
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      rethrow;
    }
  }

  // Menutup semua box Hive
  static Future<void> closeBoxes() async {
    try {
      await Hive.close();
      debugPrint('All Hive boxes closed');
    } catch (e) {
      debugPrint('Error closing Hive boxes: $e');
      rethrow;
    }
  }
}
