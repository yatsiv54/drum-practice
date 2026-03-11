import 'package:dotted_border/dotted_border.dart' as db;
import 'package:drum_practice_app/core/widgets/app_back_button.dart';
import 'package:drum_practice_app/core/widgets/app_bottom_nav.dart';
import 'package:drum_practice_app/features/presentation/plans_editor/cubit/plan_editor_cubit.dart';
import 'package:drum_practice_app/features/presentation/plans_editor/cubit/plan_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/core/widgets/app_layout.dart';
import 'package:drum_practice_app/core/widgets/custom_button.dart';

import 'package:drum_practice_app/core/di.dart';
import 'package:drum_practice_app/features/domain/repositories/exercise_repository.dart';
import 'package:drum_practice_app/features/domain/entities/exercise.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppLayout(
        leading: const AppBackButton(),
        currentTab: AppTab.plans,
        body: BlocConsumer<PlanEditorCubit, PlanEditorState>(
          listenWhen: (p, c) => p.error != c.error || p.saved != c.saved,
          listener: (ctx, s) {
            if (s.error != null) {
              ScaffoldMessenger.of(
                ctx,
              ).showSnackBar(SnackBar(content: Text(s.error!)));
            }
            if (s.saved) context.pop(true);
          },
          builder: (ctx, s) {
            final isEdit = s.id != null;
            if (_title.text != s.title) _title.text = s.title;

            final exRepo = getIt<ExerciseRepository>();
            return FutureBuilder(
              future: exRepo.getAll(),
              builder: (context, snap) {
                final all = snap.data ?? const <Exercise>[];
                final byId = {for (final e in all) e.id: e};

                final occ = <String, int>{};
                final keys = <Key>[];
                for (final id in s.exerciseIds) {
                  final n = (occ[id] ?? 0) + 1;
                  occ[id] = n;
                  keys.add(ValueKey('$id#$n'));
                }

                return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  isEdit ? 'Edit Plan' : 'Create Plan',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _filled(
                                  controller: _title,
                                  hint: 'Plan Title',
                                  onChanged: context
                                      .read<PlanEditorCubit>()
                                      .setTitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverReorderableList(
                            itemCount: s.exerciseIds.length,
                            proxyDecorator: (child, _, __) => Material(
                              type: MaterialType.transparency,
                              child: child,
                            ),
                            itemBuilder: (context, i) {
                              final id = s.exerciseIds[i];
                              final ex = byId[id];

                              return KeyedSubtree(
                                key: keys[i],
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ReorderableDragStartListener(
                                        index: i,
                                        child: const _Burger(),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: _PlanChip(
                                          title: ex?.title ?? 'Unknown',
                                          minutes: (ex?.minutes ?? 0).round(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              final cur = [...s.exerciseIds];
                              if (newIndex > oldIndex) newIndex -= 1;
                              final moved = cur.removeAt(oldIndex);
                              cur.insert(newIndex, moved);
                              context.read<PlanEditorCubit>().setExercises(cur);
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: db.DottedBorder(
                              color: Colors.white30,
                              strokeWidth: 2,
                              dashPattern: const [6, 6],
                              borderType: db.BorderType.RRect,
                              radius: const Radius.circular(5),
                              child: Container(
                                color: CustomColors.customLightBlue,
                                height: 45,
                                child: InkWell(
                                  onTap: _pickExercises,
                                  child: const Center(
                                    child: Text(
                                      '+ Add exercises from the library',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(113, 158, 197, 1),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        child: CustomButton(
                          height: 75,
                          text: isEdit ? 'Update plan' : 'Save Plan',
                          onPressed: context.read<PlanEditorCubit>().save,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickExercises() async {
    final repo = getIt<ExerciseRepository>();
    final all = await repo.getAll();
    if (all.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises in the library yet')),
      );
      return;
    }

    final current = List<String>.from(
      context.read<PlanEditorCubit>().state.exerciseIds,
    );

    final selected = <String>{};

    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CustomColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
        final maxH = MediaQuery.of(sheetCtx).size.height * 0.9;
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 40,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxH),
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.separated(
                            itemCount: all.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final e = all[i];
                              final isSel = selected.contains(e.id);
                              return _SelectTile(
                                title: e.title,
                                minutes: e.minutes.round(),
                                selected: isSel,
                                onTap: () {
                                  setModalState(() {
                                    if (isSel) {
                                      selected.remove(e.id);
                                    } else {
                                      selected.add(e.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(sheetCtx).pop(null),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(70),
                                backgroundColor: Colors.white,
                                foregroundColor: CustomColors.primaryBlue,
                                side: const BorderSide(
                                  color: CustomColors.primaryBlue,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selected.isEmpty
                                  ? null
                                  : () => Navigator.of(
                                      sheetCtx,
                                    ).pop(selected.toList()),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(70),
                                backgroundColor: CustomColors.greenForButton,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      final next = [...current, ...result];
      context.read<PlanEditorCubit>().setExercises(next);
    }
  }
}

class _SelectedExercises extends StatelessWidget {
  final List<String> ids;
  const _SelectedExercises({required this.ids});

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) return const SizedBox.shrink();

    final repo = getIt<ExerciseRepository>();
    return FutureBuilder<List<Exercise>>(
      future: repo.getAll(),
      builder: (ctx, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        final all = snap.data!;
        final byId = {for (final e in all) e.id: e};

        return Column(
          children: [
            for (int i = 0; i < ids.length; i++) ...[
              _PlanExerciseRow(
                index: i,
                exercise: byId[ids[i]],
                onRemove: () {
                  final cubit = context.read<PlanEditorCubit>();
                  final next = [...ids]..removeAt(i);
                  cubit.setExercises(next);
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

class _PlanExerciseRow extends StatelessWidget {
  final int index;
  final Exercise? exercise;
  final VoidCallback onRemove;
  const _PlanExerciseRow({
    required this.index,
    required this.exercise,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Exercise missing',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }
    final e = exercise!;
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: CustomColors.accentGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.access_time, size: 14, color: Colors.white),
                SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${e.minutes} minutes',
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              e.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(16),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.close, color: Colors.black54, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _filled({
  required TextEditingController controller,
  required String hint,
  required Function(String) onChanged,
  int maxLines = 1,
}) {
  return SizedBox(
    height: 45,
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(113, 158, 197, 1),
        ),
        filled: true,
        fillColor: CustomColors.customLightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    ),
  );
}

class _ReorderList extends StatelessWidget {
  final List<String> ids;
  final Map<String, Exercise> byId;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onRemoveAt;

  const _ReorderList({
    required this.ids,
    required this.byId,
    required this.onReorder,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    final occ = <String, int>{};
    final keys = <Key>[];
    for (final id in ids) {
      final n = (occ[id] ?? 0) + 1;
      occ[id] = n;
      keys.add(ValueKey('$id#$n'));
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      itemCount: ids.length,
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      proxyDecorator: (child, index, animation) {
        return Material(type: MaterialType.transparency, child: child);
      },
      itemBuilder: (_, i) {
        final id = ids[i];
        final e = byId[id];
        return ReorderableDelayedDragStartListener(
          key: keys[i],
          index: i,
          child: _PlanTile(
            index: i,
            title: e?.title ?? 'Unknown',
            minutes: (e?.minutes ?? 0).round(),
            onRemove: () => onRemoveAt(i),
          ),
        );
      },
    );
  }
}

class _PlanTile extends StatelessWidget {
  final int index;
  final String title;
  final int minutes;
  final VoidCallback onRemove;

  const _PlanTile({
    required this.index,
    required this.title,
    required this.minutes,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.drag_handle, color: CustomColors.accentGreen, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '$minutes min.',
            style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 18),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(16),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.close, size: 18, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String title;
  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
    required this.title,
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(233, 238, 242, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        constraints: const BoxConstraints(minHeight: 64),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: _RadioCircle(selected: selected),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '🕒 $minutes min.',
                        style: const TextStyle(
                          color: Color.fromRGBO(113, 158, 197, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? const Color.fromRGBO(31, 67, 103, 1)
              : Colors.black38,
          width: 2,
        ),
        color: selected
            ? const Color.fromRGBO(31, 67, 103, 1)
            : Colors.transparent,
      ),
      child: selected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

extension _WithMinutes on Row {
  Widget _withMinutes(String text) {
    return Row(
      children: [
        ...children,
        Text(
          '🕒 text',
          style: const TextStyle(
            color: Color(0xFF4DA3FF),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _Burger extends StatelessWidget {
  const _Burger();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (_) => Container(
            width: 18,
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: CustomColors.greenForButton,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  final String title;
  final int minutes;
  const _PlanChip({required this.title, required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.customLightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$minutes min.',
            style: TextStyle(
              color: Colors.white.withOpacity(.6),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
