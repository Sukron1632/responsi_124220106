import 'package:dio/dio.dart';
import 'package:responsi/amiibo_model.dart';


class ApiService {
  final Dio _dio = Dio();

  Future<List<AmiiboModel>> fetchAmiibos() async {
    try {
 
      final response = await _dio.get('https://www.amiiboapi.com/api/amiibo');


      if (response.data != null && response.data['amiibo'] is List) {
        return (response.data['amiibo'] as List)
            .map((item) => AmiiboModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioError catch (dioError) {

      throw Exception('DioError: ${dioError.message}');
    } catch (e) {

      throw Exception('An unexpected error occurred: $e');
    }
  }
}
