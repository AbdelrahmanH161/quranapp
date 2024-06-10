import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranApiService {
  static Future<List<dynamic>> fetchQuranArabicInfo(String surahNumber) async {
    final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/quran/quran-uthmani'));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse != null &&
          decodedResponse['data'] != null &&
          decodedResponse['data']['surahs'] != null &&
          decodedResponse['data']['surahs'][int.parse(surahNumber) - 1]
          ['ayahs'] !=
              null) {
        return decodedResponse['data']['surahs']
        [int.parse(surahNumber) - 1]['ayahs'];
      } else {
        throw Exception('Surah data not found in response');
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchQuranEnglishInfo(String surahNumber) async {
    final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/quran/en.asad'));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse != null &&
          decodedResponse['data'] != null &&
          decodedResponse['data']['surahs'] != null &&
          decodedResponse['data']['surahs'][int.parse(surahNumber) - 1]
          ['ayahs'] !=
              null) {
        return decodedResponse['data']['surahs']
        [int.parse(surahNumber) - 1]['ayahs'];
      } else {
        throw Exception('Surah data not found in response');
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
