import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Language {
  english(flag: '🇺🇸', name: 'English', code: 'en'),
  tagalog(flag: '🇵🇭', name: 'Tagalog', code: 'tl'),
  hindi(flag: '🇮🇳', name: 'हिंदी', code: 'hi'),
  korea(flag: '🇰🇷', name: '한국어', code: 'ko');

  const Language({required this.flag, required this.name, required this.code});

  final String flag;
  final String name;
  final String code;
}

final languageProvider = StateProvider<Language>((ref) => Language.english);
