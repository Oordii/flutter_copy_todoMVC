import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_todo_mvc/cubits/settings_cubit.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/global_theme.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:copy_todo_mvc/services/repositories/firestore_repository.dart';
import 'package:copy_todo_mvc/services/settings_service.dart';
import 'package:copy_todo_mvc/services/task_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<Repository>(FirestoreRepository());
  getIt.registerSingleton<TaskService>(TaskService());
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<AppRouter>(AppRouter());
}

Future<void> setupCrashlytics() async {
  if (!kIsWeb) {
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
}

Future<void> setupFacebookWebAuth() async {
  // initialiaze the facebook javascript SDK
  await FacebookAuth.i.webAndDesktopInitialize(
    appId: "454795307204293",
    cookie: true,
    xfbml: true,
    version: "v15.0",
  );
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
  Hive.registerAdapter(TaskAdapter());
}
  try {
    await Hive.openBox<Task>('tasks');
  } catch (error) {
    await Hive.deleteBoxFromDisk('tasks');
    Hive.openBox<Task>('tasks');
  }
  await Hive.openBox('settings');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupCrashlytics();

  if(kIsWeb){
    await setupFacebookWebAuth();
  }

  await setupHive();

  setupDependencyInjection();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
    path: "assets/translations",
    fallbackLocale: const Locale('en', 'US'),
    startLocale: const Locale('en', 'US'),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoListCubit()),
        BlocProvider(create: (context) => SettingsCubit())
      ],
      child: Builder(builder: (context) {
        final settingsState = context.watch<SettingsCubit>().state;
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: getIt.get<AppRouter>().config(),
          title: 'TodoMVC copy',
          themeMode: settingsState.themeMode,
          theme: GlobalTheme.light(),
          darkTheme: GlobalTheme.dark(),
          builder: (context, child) => child!,
        );
      }),
    );
  }
}
