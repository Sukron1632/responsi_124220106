import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:responsi/amiibo_model.dart';
import 'package:responsi/hive_service.dart';

class FavoriteProvider with ChangeNotifier {

  List<AmiiboModel> _favorites = [];


  List<AmiiboModel> get favorites => _favorites;


  FavoriteProvider(Box<AmiiboModel> box) {
    _loadFavorites();
  }


  void _loadFavorites() async {
    try {

      _favorites = await HiveService.getFavorites();


      for (var amiibo in _favorites) {
        amiibo.isFavorite = true;
      }


      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }


  bool isFavorite(AmiiboModel amiibo) {
    return _favorites.any((f) => f.id == amiibo.id);
  }


  Future<void> addFavorite(AmiiboModel amiibo) async {
    try {
      if (!isFavorite(amiibo)) {

        await HiveService.saveFavorite(amiibo);


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

        await HiveService.removeFavorite(amiibo);


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
   
      await HiveService.clearFavorites();

 
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
