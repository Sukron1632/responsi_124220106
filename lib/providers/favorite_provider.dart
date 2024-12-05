import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:responsi/models/amiibo_model.dart';

class FavoriteProvider with ChangeNotifier {
  final Box<AmiiboModel> _amiiboBox;

  FavoriteProvider(this._amiiboBox) {
    _loadFavorites();
  }

  List<AmiiboModel> _favorites = [];

  List<AmiiboModel> get favorites => _favorites;

  void _loadFavorites() {
    try {
      _favorites = _amiiboBox.values.toList();
      for (var amiibo in _favorites) {
        amiibo.isFavorite = true;  
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  
  bool isFavorite(AmiiboModel amiibo) {
    return _amiiboBox.containsKey(amiibo.id);
  }

  
  Future<void> addFavorite(AmiiboModel amiibo) async {
    try {
      if (!isFavorite(amiibo)) {
        await _amiiboBox.put(amiibo.id, amiibo);
        amiibo.isFavorite = true;
        _favorites.add(amiibo);
        notifyListeners(); 
      }
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  
  Future<void> removeFavorite(AmiiboModel amiibo) async {
    try {
      if (isFavorite(amiibo)) {
        await _amiiboBox.delete(amiibo.id);
        amiibo.isFavorite = false;
        _favorites.removeWhere((f) => f.id == amiibo.id);
        notifyListeners(); 
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  
  Future<void> toggleFavorite(AmiiboModel amiibo) async {
    if (isFavorite(amiibo)) {
      await removeFavorite(amiibo);
    } else {
      await addFavorite(amiibo);
    }
  }

  
  Future<void> clearFavorites() async {
    try {
      await _amiiboBox.clear();
      _favorites.clear();
      notifyListeners(); 
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  
  List<AmiiboModel> searchFavorites(String query) {
    return _favorites
        .where((amiibo) =>
            amiibo.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
