// lib/features/presentation/exercise_editor/widgets/tag_picker.dart

import 'package:drum_practice_app/core/colors.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_cubit.dart';
import 'package:drum_practice_app/features/presentation/exercise_editor/cubit/exercise_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagPickerSheet extends StatefulWidget {
  final ExerciseEditorCubit cubit;

  const TagPickerSheet({super.key, required this.cubit});

  @override
  State<TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<TagPickerSheet> {
  final nameCtrl = TextEditingController();
  Color pickedColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottom,
      ),
      child: BlocBuilder<ExerciseEditorCubit, ExerciseEditorState>(
        bloc: widget.cubit,
        builder: (ctx, state) {
          final selected = state.tags.map((e) => e.toLowerCase()).toSet();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choose tags',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (state.availableTags.isEmpty)
                  Text(
                    'No saved tags yet',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (state.availableTags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 2,
                    children: state.availableTags.map((t) {
                      final isSel = selected.contains(t.name.toLowerCase());
                      final c = Color(t.color);

                      return FilterChip(
                        label: Text(t.name),
                        selected: isSel,
                        checkmarkColor: Colors.white,
                        labelStyle: const TextStyle(color: Colors.white),
                        backgroundColor: c.withOpacity(1),
                        selectedColor: c.withOpacity(1),
                        onSelected: (_) {
                          if (isSel) {
                            widget.cubit.removeTag(t.name);
                          } else {
                            widget.cubit.addTag(t.name);
                          }
                        },
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                        onDeleted: () async {
                          await widget.cubit.deleteSavedTag(t.name);
                        },
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(.15), height: 1),
                const SizedBox(height: 12),

                Text(
                  'Create new tag',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g. warm-up',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          filled: true,
                          fillColor: Colors.transparent,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white54,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () async {
                        final result = await showDialog<Color?>(
                          context: context,
                          builder: (_) {
                            var tmp = pickedColor;
                            return AlertDialog(
                              backgroundColor: CustomColors.primaryBlue,
                              title: const Text(
                                'Pick a color',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: tmp,
                                  onColorChanged: (c) => tmp = c,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, null),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, tmp),
                                  child: Text(
                                    'Select',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null) {
                          setState(() => pickedColor = result);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: pickedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        await widget.cubit.saveNewTag(name, pickedColor.value);
                        widget.cubit.addTag(name);
                        nameCtrl.clear();
                        setState(() {});
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
