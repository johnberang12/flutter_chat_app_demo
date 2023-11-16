import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/src/features/language/data/language_repository.dart';
import 'package:flutter_chat_app/src/features/language/language.dart';
import 'package:flutter_chat_app/src/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load();

  final container = ProviderContainer();
  final language =
      await container.read(languageRepositoryProvider).getLanguage();
  runApp(ProviderScope(
      overrides: [languageProvider.overrideWith((ref) => language)],
      child: const MyApp()));
}
