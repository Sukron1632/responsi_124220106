import 'package:flutter/material.dart';
import 'package:responsi/api_card.dart';
import 'package:responsi/custom_bottom_navbar.dart';
import 'package:responsi/favorite_provider.dart';
import 'package:responsi/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout() async {
  
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();


    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            color: Colors.red,
          ),
        ],
      ),
      body: favoriteProvider.favorites.isEmpty
          ? _buildEmptyFavorites()
          : _buildFavoritesGrid(favoriteProvider),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada Amiibo favorit',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(FavoriteProvider favoriteProvider) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 0.7, 
        crossAxisSpacing: 8, 
        mainAxisSpacing: 8, 
      ),
      itemCount: favoriteProvider.favorites.length,
      itemBuilder: (context, index) {
        return AmiiboCard(
          amiibo: favoriteProvider.favorites[index], 
          onFavoriteToggle: (amiibo) {
            favoriteProvider.removeFavorite(amiibo); 
          },
          onTap: () {
            
            Navigator.pushNamed(
              context,
              '/detail', 
              arguments: favoriteProvider.favorites[index], 
            );
          },
        );
      },
    );
  }
}
