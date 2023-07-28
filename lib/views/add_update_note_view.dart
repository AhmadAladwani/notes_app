import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revise_notes/bloc/notes_bloc.dart';
import 'package:revise_notes/bloc/notes_event.dart';
import 'package:revise_notes/bloc/notes_state.dart';
import 'package:revise_notes/models/notes.dart';

class AddUpdateNoteView extends StatefulWidget {
  static const routeName = '/add_note_view';
  const AddUpdateNoteView({super.key});

  @override
  State<AddUpdateNoteView> createState() => _AddUpdateNoteViewState();
}

class _AddUpdateNoteViewState extends State<AddUpdateNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Note? note;
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userId = arguments['userId'] as String;
    final bool updatingNote = arguments['note'] != null;
    if (updatingNote) {
      note = arguments['note'] as Note;
      _titleController.text = note.title;
      _descriptionController.text = note.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: updatingNote ? const Text('Update Note') : const Text('Notes'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter the Title.';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              controller: _descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter the Description.';
                } else {
                  return null;
                }
              },
            ),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) => TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    if (updatingNote) {
                      context.read<NotesBloc>().add(NotesEventUpdate(
                            userId: userId,
                            noteId: note!.id,
                            title: title,
                            description: description,
                          ));
                    } else {
                      context.read<NotesBloc>().add(
                            NotesEventAdd(
                              userId: userId,
                              title: title,
                              description: description,
                            ),
                          );
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
