import 'package:five/service/client/api_client.dart';
import '../../model/daily_word.dart';

class DailyWordRepository {
  final ApiClient client;

  DailyWordRepository({required this.client});

  Future<DailyWord?> fetchDailyWord() async {
    String url = "https://cqps5q3rof.execute-api.sa-east-1.amazonaws.com/default/fetchDailyWord";

    try {
      var response = await client.dio.get(url);
      return DailyWord.fromJson(response.data);
    } catch(e) {
      return null;
    }
  }
}
