import 'package:get_it/get_it.dart';
import 'package:five/service/client/api_client.dart';
import 'package:five/service/repository/daily_word_repository.dart';
import 'package:five/service/usecase/fetch_daily_word_usecase.dart';
import 'package:five/store/main_store.dart';
import 'package:five/store/player_history_store.dart';

final GetIt serviceLocator = GetIt.I;

void setupLocator() {

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
