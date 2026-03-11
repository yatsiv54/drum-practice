import 'package:drum_practice_app/features/data/repositories/plan_repository_impl.dart';
import 'package:drum_practice_app/features/data/repositories/tag_repository_impl.dart';
import 'package:drum_practice_app/features/data/repositories/timer_repository_impl.dart';
import 'package:drum_practice_app/features/domain/repositories/plan_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/tag_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/timer_repository.dart';
import 'package:drum_practice_app/features/presentation/plans/cubit/plans_list_cubit.dart';
import 'package:drum_practice_app/features/presentation/plans_details/cubit/plan_details_cubit.dart';
import 'package:drum_practice_app/features/presentation/plans_editor/cubit/plan_editor_cubit.dart';
import 'package:drum_practice_app/features/presentation/timer/cubit/timer_cubit.dart';
import 'package:get_it/get_it.dart';

import 'package:drum_practice_app/features/data/repositories/session_repository_impl.dart';
import 'package:drum_practice_app/features/data/repositories/exercise_repository_impl.dart';
import 'package:drum_practice_app/features/domain/repositories/session_repository.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';

import 'package:drum_practice_app/features/presentation/home/cubit/home_exercises_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_library/cubit/exercise_list_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  
  // --- Repositories ---
  getIt.registerLazySingleton<TagRepository>(() => TagRepositoryImpl());
  getIt.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl());
  getIt.registerLazySingleton<ExerciseRepository>(() => ExerciseRepositoryImpl());
  getIt.registerLazySingleton<PlanRepository>(() => PlanRepositoryImpl());
  getIt.registerLazySingleton<TimerRepository>(() => TimerRepositoryImpl());


  // --- Cubits ---

  getIt.registerFactory<HomeExercisesCubit>(() => HomeExercisesCubit(getIt()));
  getIt.registerFactory<PlansListCubit>(() => PlansListCubit(getIt()));
  getIt.registerFactory<PlanEditorCubit>(() => PlanEditorCubit(getIt(), getIt()));
  getIt.registerFactory<PlanDetailsCubit>(() => PlanDetailsCubit(getIt(), getIt()));
  getIt.registerFactory<ExerciseListCubit>(() => ExerciseListCubit(getIt<ExerciseRepository>()));
  getIt.registerFactory<TimerCubit>(() => TimerCubit(
  getIt<PlanRepository>(),
  getIt<ExerciseRepository>(),
  getIt<TimerRepository>(),
));


  getIt.registerFactoryParam<ExerciseEditorCubit, String?, void>(
    (id, _) => ExerciseEditorCubit(
      getIt<ExerciseRepository>(),
      getIt<TagRepository>(),
      editId: id,
   ));
  
}

Future<void> resetDependencies() async {
  await getIt.reset(dispose: false);
}
