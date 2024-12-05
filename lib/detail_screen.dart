import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:responsi/amiibo_model.dart';
import 'package:responsi/favorite_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class DetailScreen extends StatelessWidget {
  final AmiiboModel amiibo;

  const DetailScreen({super.key, required this.amiibo});

  Future<void> _checkSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {

    _checkSession(context);

    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        bool isFavorite = favoriteProvider.isFavorite(amiibo);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(amiibo.name),
                  background: CachedNetworkImage(
                    imageUrl: amiibo.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Deskripsi'),
                        const SizedBox(height: 8),
                        Text(
                          amiibo.description.isNotEmpty
                              ? amiibo.description
                              : 'Tidak ada deskripsi tersedia',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTitle(context, 'Kategori'),
                        const SizedBox(height: 8),
                        Text(
                          amiibo.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTitle(context, 'Detail Lainnya'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Game Asal:', amiibo.gameOrigin),
                        _buildDetailRow('Karakter:', amiibo.character),
                        _buildDetailRow('Tipe:', amiibo.type),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _toggleFavorite(context, favoriteProvider);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            label: Text(
                              isFavorite
                                  ? 'Hapus dari Favorit'
                                  : 'Tambah ke Favorit',
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  isFavorite ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context, FavoriteProvider favoriteProvider) {
    if (favoriteProvider.isFavorite(amiibo)) {
      favoriteProvider.removeFavorite(amiibo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${amiibo.name} dihapus dari favorit'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      favoriteProvider.addFavorite(amiibo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${amiibo.name} ditambahkan ke favorit'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
