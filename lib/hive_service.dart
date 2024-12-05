import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:responsi/amiibo_model.dart';



class HiveService {
  static const String _favoritesBoxName = 'favorites';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();




   
      await _openBoxes();
    } catch (e) {
      debugPrint('Hive initialization error: $e');
      rethrow;
    }
  }

  static Future<void> _openBoxes() async {
    try {
    


      if (!Hive.isBoxOpen(_favoritesBoxName)) {
        await Hive.openBox<AmiiboModel>(_favoritesBoxName);
      }
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
      rethrow;
    }
  }


  static Future<void> saveFavorite(AmiiboModel amiibo) async {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);

      if (!favBox.values.any((existingAmiibo) => existingAmiibo.id == amiibo.id)) {
        await favBox.put(amiibo.id, amiibo);
        debugPrint('Amiibo ${amiibo.name} saved to favorites');
      }
    } catch (e) {
      debugPrint('Error saving favorite: $e');
      rethrow;
    }
  }


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

  static List<AmiiboModel> getFavorites() {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      return favBox.values.toList();
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  static bool isFavorite(AmiiboModel amiibo) {
    try {
      final favBox = Hive.box<AmiiboModel>(_favoritesBoxName);
      return favBox.containsKey(amiibo.id);
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
      return false;
    }
  }

 
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
