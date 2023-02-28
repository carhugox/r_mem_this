import 'package:flutter/material.dart';
import 'package:r_mem_this/models/note_model.dart';
import 'package:r_mem_this/pages/add_note_page.dart';
import 'package:r_mem_this/pages/note_description_page.dart';
import 'package:r_mem_this/pages/notes_main_page.dart';

class AppNavigator {
  static void gotoAddNotePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNotePage(),
      ),
    );
  }

  static void gotoMainPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const NotesMainPage(),
      ),
      (r) => false,
    );
  }

  static void gotoNoteDescriptionPage(BuildContext context, NoteModel note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDescriptionPage(
          note: note,
        ),
      ),
    );
  }
}
