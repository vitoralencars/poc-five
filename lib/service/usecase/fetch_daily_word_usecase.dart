import 'package:pocs_flutter/service/repository/daily_word_repository.dart';
import '../../model/daily_word.dart';

class FetchDailyWordUseCase {
  FetchDailyWordUseCase({required this.repository});

  DailyWordRepository repository;

  Future<DailyWord?> execute() async {
    return await repository.fetchDailyWord();
  }
}
