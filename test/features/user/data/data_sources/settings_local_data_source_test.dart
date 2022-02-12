import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box {}

void main() {
  // late SettingsLocalDataSourceImpl dataSource;
  // late MockBox mockBox;
  //
  // setUpAll(() {
  //   Hive.init(Directory.systemTemp.path);
  // });
  //
  // setUp(() {
  //   mockBox = MockBox();
  //   dataSource = SettingsLocalDataSourceImpl(settingsBox: mockBox);
  // });
  //
  // group('getLocalSettings', () {
  //   final tSettingsModel = SettingsModel.fromMap(
  //     jsonDecode(fixture('user.json')) as Map,
  //   );
  //
  //   test(
  //     '''
  //   should return [SettingsModel] from [Box]
  //   when there is one in the cache''',
  //     () async {
  //       when(() => mockBox.toMap()).thenReturn(
  //         jsonDecode(fixture('user.json')) as Map,
  //       );
  //       when(() => mockBox.isEmpty).thenReturn(false);
  //       when(() => mockBox.isNotEmpty).thenReturn(true);
  //
  //       final result = await dataSource.getLocalSettings();
  //
  //       verify(() => mockBox.toMap());
  //       expect(result, equals(tSettingsModel));
  //     },
  //   );
  //
  //   test(
  //     'should throw a [CacheException] when there is not a cached value',
  //     () async {
  //       when(() => mockBox.toMap()).thenReturn({});
  //       when(() => mockBox.isEmpty).thenReturn(true);
  //       when(() => mockBox.isNotEmpty).thenReturn(false);
  //
  //       final call = dataSource.getLocalSettings;
  //
  //       expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
  //     },
  //   );
  // });
  //
  // group('cacheSettings', () {
  //   final tSettingsModel = SettingsModel(
  //     isStartup: false,
  //     themeMode: ThemeMode.dark,
  //     nativeLanguage: Languages.english,
  //   );
  //
  //   test(
  //     'should call SharedPreferences to cache the data',
  //     () async {
  //       when(() => mockBox.putAll(any())).thenAnswer((_) => Future.value());
  //
  //       await dataSource.cacheSettings(tSettingsModel);
  //
  //       final expectedMap = tSettingsModel.toMap();
  //       verify(
  //         () => mockBox.putAll(expectedMap),
  //       );
  //     },
  //   );
  // });
}
