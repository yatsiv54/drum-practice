import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../domain/entities/exercise.dart';
import '../cubit/home_exercises_cubit.dart';
import '../cubit/home_exercises_state.dart';
import '../../../../core/di.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeExercisesCubit>(
      create: (_) => getIt<HomeExercisesCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Training Sessions',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<HomeExercisesCubit, HomeExercisesState>(
                builder: (context, state) => state.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (m) => Center(
                    child: Text(m, style: const TextStyle(color: Colors.white)),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No exercises yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _ExerciseCard(e: items[i]),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            
            Padding(
              padding: EdgeInsets.fromLTRB(
                8,
                8,
                8,
                MediaQuery.of(context).padding.bottom + 0,
              ),
              child: CustomButton(
                height: 75,
                text: 'Create New Session',
                onPressed: () async {
                  final created = await context.push<bool>('/library/exercises/create');
                  if (created == true && context.mounted) {
                    context.read<HomeExercisesCubit>().refresh();
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),

      
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise e;
  const _ExerciseCard({required this.e});

  @override
  Widget build(BuildContext context) {
    final dateTxt =
        'Date: ${_monthName(e.createdAt.month)} ${e.createdAt.day}, ${e.createdAt.year}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '📅 $dateTxt',
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              _MinutesPill(minutes: e.minutes),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            e.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.push(
                '/library/exercises/${Uri.encodeComponent(e.id)}',
                extra: e,
              ),
              child: const Padding(
                padding: EdgeInsets.only(right: 6, bottom: 2),
                child: Text(
                  'View Details',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 112, 224, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromRGBO(0, 112, 224, 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MinutesPill extends StatelessWidget {
  final int minutes;
  const _MinutesPill({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CustomColors.greenForButton,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🕒 ',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          Text(
            '$minutes minutes',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

String _monthName(int m) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][m - 1];
