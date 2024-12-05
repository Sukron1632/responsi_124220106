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

  // Fungsi untuk memuat favorit dari Box
  void _loadFavorites() {
    try {
      _favorites = _amiiboBox.values.toList();
      for (var amiibo in _favorites) {
        amiibo.isFavorite = true;  // Menandai semua amiibo sebagai favorit
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Cek apakah amiibo sudah ada dalam daftar favorit
  bool isFavorite(AmiiboModel amiibo) {
    return _amiiboBox.containsKey(amiibo.id);
  }

  // Fungsi untuk menambahkan amiibo ke favorit
  Future<void> addFavorite(AmiiboModel amiibo) async {
    try {
      if (!isFavorite(amiibo)) {
        await _amiiboBox.put(amiibo.id, amiibo);
        amiibo.isFavorite = true;
        _favorites.add(amiibo);
        notifyListeners(); // Menginformasikan perubahan pada widget yang mendengarkan
      }
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  // Fungsi untuk menghapus amiibo dari favorit
  Future<void> removeFavorite(AmiiboModel amiibo) async {
    try {
      if (isFavorite(amiibo)) {
        await _amiiboBox.delete(amiibo.id);
        amiibo.isFavorite = false;
        _favorites.removeWhere((f) => f.id == amiibo.id);
        notifyListeners(); // Menginformasikan perubahan pada widget yang mendengarkan
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  // Fungsi untuk toggle status favorit amiibo
  Future<void> toggleFavorite(AmiiboModel amiibo) async {
    if (isFavorite(amiibo)) {
      await removeFavorite(amiibo);
    } else {
      await addFavorite(amiibo);
    }
  }

  // Fungsi untuk membersihkan semua favorit
  Future<void> clearFavorites() async {
    try {
      await _amiiboBox.clear();
      _favorites.clear();
      notifyListeners(); // Menginformasikan perubahan pada widget yang mendengarkan
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  // Fungsi untuk mencari favorit berdasarkan nama
  List<AmiiboModel> searchFavorites(String query) {
    return _favorites
        .where((amiibo) =>
            amiibo.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
