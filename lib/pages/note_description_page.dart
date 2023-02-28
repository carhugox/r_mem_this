import 'package:flutter/material.dart';
import 'package:r_mem_this/models/note_model.dart';

import '../utils/string_uitils.dart';

class NoteDescriptionPage extends StatefulWidget {
  final NoteModel note;
  const NoteDescriptionPage({super.key, required this.note});

  @override
  State<NoteDescriptionPage> createState() => _NoteDescriptionPageState();
}

class _NoteDescriptionPageState extends State<NoteDescriptionPage> {
  NoteModel get note => widget.note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              capitalize(note.tittle),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              note.text ?? capitalize(note.text),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
