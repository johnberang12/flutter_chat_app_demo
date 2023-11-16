import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../language.dart';

class LanguageRepository {
  LanguageRepository({required this.ref});
  final Ref ref;

  static const String languageCodeKey = "language_code";

  Future<void> setLanguage(Language language) async {
    final pref = await ref.read(sharedPreferecesProvider.future);
    await pref.setString(languageCodeKey, language.code);
    ref.read(languageProvider.notifier).update((_) => language);
  }

  Future<Language> getLanguage() async {
    final pref = await ref.read(sharedPreferecesProvider.future);
    final code = pref.getString(languageCodeKey);
    for (var value in Language.values) {
      if (value.code == code) return value;
    }
    return Language.english;
  }
}

final sharedPreferecesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final languageRepositoryProvider =
    Provider<LanguageRepository>((ref) => LanguageRepository(ref: ref));
