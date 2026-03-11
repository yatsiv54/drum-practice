// lib/routing/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di.dart';
import '../core/widgets/app_layout.dart';
import '../core/widgets/app_bottom_nav.dart';

// Splash / Welcome / Settings
import 'package:drum_practice_app/features/presentation/splash/view/splash_screen.dart';
import 'package:drum_practice_app/features/presentation/welcome/view/welcome_screen.dart';
import 'package:drum_practice_app/features/presentation/settings/view/settings_screen.dart';

// Tabs
import 'package:drum_practice_app/features/presentation/home/view/home_screen.dart';
import 'package:drum_practice_app/features/presentation/home/cubit/home_exercises_cubit.dart';

import 'package:drum_practice_app/features/presentation/exercise_library/view/library_screen.dart';
import 'package:drum_practice_app/features/presentation/exercise_library/cubit/exercise_list_cubit.dart';

import 'package:drum_practice_app/features/presentation/plans/view/plans_screen.dart';
import 'package:drum_practice_app/features/presentation/plans/cubit/plans_list_cubit.dart';

import 'package:drum_practice_app/features/presentation/timer/view/timer_screen.dart';
import 'package:drum_practice_app/features/presentation/timer/cubit/timer_cubit.dart';

import 'package:drum_practice_app/features/presentation/schools/view/schools_screen.dart';

// Exercises (details/editor)
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/presentation/exercise_details/view/exercise_details_screen.dart';
import 'package:drum_practice_app/features/presentation/exercise_details/cubit/exercise_details_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/view/exercise_create_screen.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_cubit.dart';

// Plans (details/editor)
import 'package:drum_practice_app/features/presentation/plans_editor/view/create_plans_screen.dart';
import 'package:drum_practice_app/features/presentation/plans_editor/cubit/plan_editor_cubit.dart';
import 'package:drum_practice_app/features/presentation/plans_details/view/plans_details_screen.dart';

// ---------------- Keys ----------------
final _rootKey    = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeKey    = GlobalKey<NavigatorState>(debugLabel: 'home');
final _libraryKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final _plansKey   = GlobalKey<NavigatorState>(debugLabel: 'plans');
final _timerKey   = GlobalKey<NavigatorState>(debugLabel: 'timer');
final _schoolsKey = GlobalKey<NavigatorState>(debugLabel: 'schools');
final _settingsKey= GlobalKey<NavigatorState>(debugLabel: 'settings');

Page<T> _noTxPage<T>(Widget child) => NoTransitionPage<T>(child: child);

// індекс гілки Settings у shell (після 5 табів: 0..4)
const int _settingsBranchIndex = 5;
// останній “реальний” таб (щоб підсвітка не зникала, коли ми у Settings)
int _lastRealTabIndex = 0;

final GoRouter router = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/splash',
  routes: [
    // ---- Поза shell (повноекранні сторінки) ----
    GoRoute(
      path: '/splash',
      pageBuilder: (_, __) => _noTxPage(const SplashScreen()),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (_, __) => _noTxPage(const WelcomeScreen()),
    ),

    // ---------- Shell з IndexedStack (збереження станів) ----------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // safeIndex: якщо ми у Settings-гілці (індекс 5), залишаємо підсвіченим останній реальний таб
        final totalTabs = AppTab.values.length; // 5
        final rawIndex  = navigationShell.currentIndex;
        final isSettings = rawIndex >= totalTabs;
        final safeIndex = isSettings ? _lastRealTabIndex : rawIndex;
        if (!isSettings) _lastRealTabIndex = safeIndex;

        final current = AppTab.values[safeIndex];

        return AppLayout(
          body: navigationShell,
          currentTab: current,
          shell: navigationShell,
          settingsBranchIndex: _settingsBranchIndex, // для кнопки в AppBar
        );
      },
      branches: [
        // 0) HOME
        StatefulShellBranch(
          navigatorKey: _homeKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (_, __) => _noTxPage(
                BlocProvider<HomeExercisesCubit>(
                  create: (_) => getIt<HomeExercisesCubit>(),
                  child: const HomeScreen(),
                ),
              ),
            ),
          ],
        ),

        // 1) LIBRARY (+ вкладені сторінки поверх shell через root)
        StatefulShellBranch(
          navigatorKey: _libraryKey,
          routes: [
            GoRoute(
              path: '/library',
              pageBuilder: (_, __) => _noTxPage(
                BlocProvider<ExerciseListCubit>(
                  create: (_) => getIt<ExerciseListCubit>(),
                  child: const LibraryScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'exercises/create',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => BlocProvider<ExerciseEditorCubit>(
                    create: (_) => getIt<ExerciseEditorCubit>(param1: null),
                    child: const CreateExerciseScreen(),
                  ),
                ),
                GoRoute(
                  path: 'exercises/:id/edit',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => BlocProvider<ExerciseEditorCubit>(
                    create: (_) => getIt<ExerciseEditorCubit>(
                      param1: state.pathParameters['id'],
                    ),
                    child: const CreateExerciseScreen(),
                  ),
                ),
                GoRoute(
                  path: 'exercises/:id',
                  parentNavigatorKey: _rootKey,
                  builder: (ctx, s) {
                    final ex = s.extra is Exercise ? s.extra as Exercise : null;
                    return BlocProvider(
                      create: (_) => ExerciseDetailsCubit(
                        getIt(), // ExerciseRepository
                        getIt(), // TagRepository
                        s.pathParameters['id']!,
                        initial: ex,
                      ),
                      child: const ExerciseDetailsScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // 2) PLANS
        StatefulShellBranch(
          navigatorKey: _plansKey,
          routes: [
            GoRoute(
              path: '/plans',
              pageBuilder: (_, __) => _noTxPage(
                BlocProvider(
                  create: (_) => getIt<PlansListCubit>()..watch(),
                  child: const PlansScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _rootKey,
                  builder: (ctx, s) => BlocProvider(
                    create: (_) => getIt<PlanEditorCubit>(),
                    child: const CreatePlanScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id/edit',
                  parentNavigatorKey: _rootKey,
                  builder: (ctx, s) => BlocProvider(
                    create: (_) => getIt<PlanEditorCubit>()
                      ..loadForEdit(s.pathParameters['id']!),
                    child: const CreatePlanScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootKey,
                  builder: (ctx, s) =>
                      PlanDetailsScreen(planId: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),

        // 3) TIMER
        StatefulShellBranch(
          navigatorKey: _timerKey,
          routes: [
            GoRoute(
              path: '/timer',
              pageBuilder: (_, __) => _noTxPage(
                BlocProvider<TimerCubit>(
                  create: (_) => getIt<TimerCubit>(),
                  child: const TimerScreen(),
                ),
              ),
            ),
          ],
        ),

        // 4) SCHOOLS
        StatefulShellBranch(
          navigatorKey: _schoolsKey,
          routes: [
            GoRoute(
              path: '/schools',
              pageBuilder: (_, __) => _noTxPage(const SchoolsScreen()),
            ),
          ],
        ),

        // 5) SETTINGS — окрема гілка shell (щоб зберігався стан)
        StatefulShellBranch(
          navigatorKey: _settingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (_, __) => _noTxPage(const SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
