import 'package:get_it/get_it.dart';
import 'package:pocs_flutter/service/client/api_client.dart';
import 'package:pocs_flutter/service/repository/daily_word_repository.dart';
import 'package:pocs_flutter/service/usecase/fetch_daily_word_usecase.dart';
import 'package:pocs_flutter/viewmodel/home_view_model.dart';

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

  //ViewModel
  serviceLocator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
}
