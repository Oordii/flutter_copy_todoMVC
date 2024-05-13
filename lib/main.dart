import 'package:copy_todo_mvc/cubits/settings_cubit.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/global_theme.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:copy_todo_mvc/services/repositories/hive_repository.dart';
import 'package:copy_todo_mvc/services/settings_service.dart';
import 'package:copy_todo_mvc/services/task_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'firebase_options.dart';


final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<Repository>(HiveRepository());
  getIt.registerSingleton<TaskService>(TaskService());
  getIt.registerSingleton<SettingsService>(SettingsService());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  try {
    await Hive.openBox<Task>('tasks');
  } catch (error){
    await Hive.deleteBoxFromDisk('tasks');
    Hive.openBox<Task>('tasks');
  }
  await Hive.openBox('settings');

  setup();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
    path: "assets/translations",
    fallbackLocale: const Locale('en', 'US'),
    startLocale: const Locale('en', 'US'),
    child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoListCubit()),
        BlocProvider(create: (context) => SettingsCubit())
      ],
      child: Builder(
        builder: (context) {
          final settingsState = context.watch<SettingsCubit>().state;
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: _appRouter.config(),
            title: 'TodoMVC copy',
            themeMode: settingsState.themeMode,
            theme: GlobalTheme.light(),
            darkTheme: GlobalTheme.dark(),
            builder: (context, child) => child!,
          );
        }
      ),
    );
  }
}
