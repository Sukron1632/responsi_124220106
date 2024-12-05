import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/amiibo_model.dart';

class DetailScreen extends StatelessWidget {
  final AmiiboModel amiibo;

  const DetailScreen({super.key, required this.amiibo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amiibo Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: amiibo.imageUrl.isNotEmpty
                        ? amiibo.imageUrl
                        : 'https://via.placeholder.com/150', 
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 100, color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              
              Center(
                child: Text(
                  amiibo.name.isNotEmpty ? amiibo.name : 'Unknown Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Informasi Utama
              _buildInfoCard([
                _buildDetailRow('Amiibo Series:', amiibo.amiiboSeries?['default'] ?? 'Unknown'),
                _buildDetailRow('Character:', amiibo.character.isNotEmpty ? amiibo.character : 'Unknown'),
                _buildDetailRow('Game Series:', amiibo.gameSeries.isNotEmpty ? amiibo.gameSeries : 'Unknown'),
                _buildDetailRow('Type:', amiibo.type.isNotEmpty ? amiibo.type : 'Unknown'),
                _buildDetailRow('Head:', amiibo.head.isNotEmpty ? amiibo.head : 'Unknown'),
                _buildDetailRow('Tail:', amiibo.tail.isNotEmpty ? amiibo.tail : 'Unknown'),
              ]),

              const SizedBox(height: 16),

              // Release Dates
              if (amiibo.releaseDates != null && amiibo.releaseDates!.isNotEmpty)
                _buildReleaseDates(amiibo.releaseDates!)
              else
                const Text(
                  'Release Dates: Not Available',
                  style: TextStyle(color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildReleaseDates(Map<String, String> releaseDates) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Release Dates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            ...releaseDates.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
