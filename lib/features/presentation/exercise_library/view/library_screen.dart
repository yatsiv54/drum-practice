import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';
import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';
import 'package:drum_practice_app/features/presentation/exercise_library/cubit/exercise_list_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_library/cubit/exercise_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExerciseListCubit>(
      create: (_) => getIt<ExerciseListCubit>()..load(),
      child: const _LibraryView(),
    );
  }
}

class _LibraryView extends StatefulWidget {
  const _LibraryView();

  @override
  State<_LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<_LibraryView> {
  final _searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchC.addListener(() {
      context.read<ExerciseListCubit>().search(_searchC.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Text('Library', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            _SearchField(controller: _searchC),
            const SizedBox(height: 16),

            // список скролиться в межах Expanded і не перекриває кнопку
            Expanded(
              child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
                builder: (context, state) => state.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (msg) => Center(
                    child: Text(
                      msg,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return const _EmptyStub();
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, i) => InkWell(
                        onTap: () => context.push(
                          '/library/exercises/${Uri.encodeComponent(items[i].id)}',
                          extra: items[i],
                        ),
                        child: _ExerciseCard(e: items[i]),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // закріплена кнопка знизу (як у PlansScreen)
            Padding(
              padding: EdgeInsets.fromLTRB(
                8,
                8,
                8,
                MediaQuery.of(context).padding.bottom +
                    0, // підняти над нижнім баром
              ),
              child: CustomButton(
                height: 75,
                text: '+ Add Exercise',
                onPressed: () => context.push('/library/exercises/create'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () {
                  controller.clear();
                  FocusScope.of(context).unfocus();
                  context.read<ExerciseListCubit>().search('');
                },
              ),
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
        '${_monthName(e.createdAt.month)} ${e.createdAt.day}, ${e.createdAt.year}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '📅 Date: $dateTxt',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.greenForButton,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '🕒 ${e.minutes} minutes',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            e.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            e.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              height: 1.3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStub extends StatelessWidget {
  const _EmptyStub();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No exercises yet',
        style: TextStyle(color: Colors.white.withOpacity(.8), fontSize: 16),
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
