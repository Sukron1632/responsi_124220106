import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/amiibo_model.dart';
import 'package:responsi/api_card.dart';
import 'package:responsi/api_service.dart';
import 'package:responsi/custom_bottom_navbar.dart';
import 'package:responsi/detail_screen.dart';
import 'package:responsi/favorite_provider.dart';
import 'package:responsi/favorite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<AmiiboModel> _amiibos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAmiibos();
  }

  Future<void> _fetchAmiibos() async {
    try {
      final amiibos = await _apiService.fetchAmiibos();
      setState(() {
        _amiibos = amiibos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Amiibos')),
      );
    }
  }

  void _toggleFavorite(AmiiboModel amiibo) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    if (favoriteProvider.isFavorite(amiibo)) {
      favoriteProvider.removeFavorite(amiibo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${amiibo.name} removed from favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      favoriteProvider.addFavorite(amiibo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${amiibo.name} added to favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToDetail(AmiiboModel amiibo) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailScreen(amiibo: amiibo)));
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Amiibo Collection'),
            automaticallyImplyLeading: false,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _amiibos.length,
                  itemBuilder: (context, index) {
                    final amiibo = _amiibos[index];
                    return AmiiboCard(
                      amiibo: amiibo,
                      onFavoriteToggle: _toggleFavorite,
                      onTap: () => _navigateToDetail(amiibo),
                    );
                  },
                ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()));
              }
            },
          ),
        );
      },
    );
  }
}
