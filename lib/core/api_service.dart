import 'package:poke_cap/global_exports.dart' show Dio, BaseOptions;

class APIService {
  late final Dio _dio;

  final String baseUrl;

  late final Map<String, dynamic> typesDataMap;

  APIService({required this.baseUrl}) {
    typesDataMap = {};    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: 5000), // Corrected
      receiveTimeout: Duration(milliseconds: 3000), // Corrected
    ));
  }

  Future<dynamic> fetchAndReturnAsJsonDecoded(String url) async {
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
        'Failed to load data from $url (Status: ${response.statusCode})',
      );
    }
  }
}
