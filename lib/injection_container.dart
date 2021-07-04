import 'package:easy_language/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:easy_language/features/settings/domain/repositories/settings_repository.dart';
import 'package:easy_language/features/settings/domain/use_cases/change_settings.dart';
import 'package:easy_language/features/settings/domain/use_cases/get_settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/settings/data/repositories/settings_repository_impl.dart';

final sl = GetIt.instance;

Future registerSettings() async {
  // bloc
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      changeSettings: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => ChangeSettings(sl()));

  // repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

Future init() async {
  // Features
  await registerSettings();
}
