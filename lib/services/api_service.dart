import 'package:dio/dio.dart';
import '../models/amiibo_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<AmiiboModel>> fetchAmiibos() async {
    try {
      
      final response = await _dio.get('https://www.amiiboapi.com/api/amiibo');

      
      if (response.data != null && response.data['amiibo'] is List) {
        List amiiboData = response.data['amiibo'];

        
        return amiiboData.map((item) {
          try {
            return item != null
                ? AmiiboModel.fromJson(item) 
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
                    amiiboSeries: {'default': 'Unknown'}, 
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
              amiiboSeries: {'default': 'Unknown'}, 
              isFavorite: false,
            );
          }
        }).toList();
      } else {
        throw Exception('Unexpected response format or missing "amiibo" key');
      }
    } on DioError catch (dioError) {
      
      print('DioError: ${dioError.message}');
      throw Exception('Failed to fetch amiibos: ${dioError.message}');
    } catch (e) {
      
      print('Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
