import 'package:get_it/get_it.dart';
import 'package:pocs_flutter/service/client/api_client.dart';
import 'package:pocs_flutter/service/repository/daily_word_repository.dart';
import 'package:pocs_flutter/service/usecase/fetch_daily_word_usecase.dart';
import 'package:pocs_flutter/store/main_store.dart';
import 'package:pocs_flutter/store/player_history_store.dart';

final GetIt serviceLocator = GetIt.I;

Future<void> setupLocator() async {
  //Client
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());

  //Repository
  serviceLocator.registerLazySingleton<DailyWordRepository>(() =>
    DailyWordRepository(client: serviceLocator<ApiClient>())
  );

  //UseCase
  serviceLocator.registerLazySingleton<FetchDailyWordUseCase>(() =>
    FetchDailyWordUseCase(repository: serviceLocator<DailyWordRepository>())
  );

  //Store
  serviceLocator.registerLazySingleton<MainStore>(() => MainStore());
  serviceLocator.registerLazySingleton<PlayerHistoryStore>(() =>
    PlayerHistoryStore()
  );
}
