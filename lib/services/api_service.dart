import 'package:dio/dio.dart';
import '../models/amiibo_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<AmiiboModel>> fetchAmiibos() async {
    try {
      // Mengirim permintaan GET ke endpoint API Amiibo
      final response = await _dio.get('https://www.amiiboapi.com/api/amiibo');

      // Validasi respons
      if (response.data != null && response.data['amiibo'] is List) {
        List amiiboData = response.data['amiibo'];

        // Memetakan data dari JSON ke objek AmiiboModel
        return amiiboData.map((item) {
          try {
            return item != null
                ? AmiiboModel.fromJson(item) // Parsing per item
                : AmiiboModel(
                    id: '',
                    name: 'Unknown',
                    character: 'Unknown',
                    imageUrl: '',
                    gameSeries: 'Unknown',
                    type: 'Unknown',
                    head: 'Unknown',
                    tail: 'Unknown',
                    releaseDates: null,
                    amiiboSeries: {'default': 'Unknown'}, // Menambahkan default amiiboSeries
                    isFavorite: false,
                  );
          } catch (e) {
            print("Error parsing amiibo item: $e");
            return AmiiboModel(
              id: 'Unknown',
              name: 'Unknown',
              character: 'Unknown',
              imageUrl: '',
              gameSeries: 'Unknown',
              type: 'Unknown',
              head: 'Unknown',
              tail: 'Unknown',
              releaseDates: null,
              amiiboSeries: {'default': 'Unknown'}, // Fallback untuk data error
              isFavorite: false,
            );
          }
        }).toList();
      } else {
        throw Exception('Unexpected response format or missing "amiibo" key');
      }
    } on DioError catch (dioError) {
      // Menangani kesalahan yang spesifik pada Dio
      print('DioError: ${dioError.message}');
      throw Exception('Failed to fetch amiibos: ${dioError.message}');
    } catch (e) {
      // Menangani kesalahan lainnya
      print('Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
