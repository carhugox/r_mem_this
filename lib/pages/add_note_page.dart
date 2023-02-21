import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:r_mem_this/models/note_model.dart';
import 'package:r_mem_this/navigator/app_navigator.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _tittleFieldController = TextEditingController();
  final _tittleFocusNode = FocusNode();
  final _descriptionFieldController = TextEditingController();
  final LocalStorage storage = LocalStorage('notes');

  bool _error = false;

  @override
  void initState() {
    super.initState();
    _tittleFieldController.addListener(() {
      if (_error) {
        setState(() {
          _error = false;
        });
      }
    });
  }

  void _saveNote(NoteModel note, DateTime date) {
    final allNotesString = storage.getItem('ALL');
    if (allNotesString != null) {
      final notesJson = jsonDecode(allNotesString) as List;
      final notes = notesJson
          .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      notes.add(note);
      storage.setItem('ALL', jsonEncode(notes));
    } else {
      final list = [];
      list.add(note.toJson());
      storage.setItem('ALL', jsonEncode(list));
    }
    AppNavigator.gotoMainPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar nota'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: TextField(
              controller: _tittleFieldController,
              focusNode: _tittleFocusNode,
              decoration: InputDecoration(
                labelText: 'Titulo',
                errorText: _error ? 'Necesitas agregar un titulo.' : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: TextField(
              maxLines: null,
              controller: _descriptionFieldController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tittleFieldController.text.isEmpty) {
            setState(() {
              _error = true;
            });
            _tittleFocusNode.requestFocus();
          } else {
            setState(() {
              _error = false;
            });
            final date = DateTime.now();
            final note = NoteModel(
              tittle: _tittleFieldController.text,
              text: _descriptionFieldController.text,
              date: date,
            );
            _saveNote(note, date);
          }
        },
        tooltip: 'Agregar',
        child: const Icon(Icons.save),
      ),
    );
  }
}
