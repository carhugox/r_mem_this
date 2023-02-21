import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:r_mem_this/navigator/app_navigator.dart';

import '../models/note_model.dart';
import '../utils/string_uitils.dart';

class NotesMainPage extends StatefulWidget {
  const NotesMainPage({super.key});
  @override
  State<NotesMainPage> createState() => _NotesMainPageState();
}

class _NotesMainPageState extends State<NotesMainPage> {
  List<NoteModel> items = [];
  bool initialized = false;
  final LocalStorage storage = LocalStorage('notes');

  List<NoteModel> loadStorage() {
    final allNotesString = storage.getItem('ALL');
    if (allNotesString != null) {
      final notesJson = jsonDecode(allNotesString) as List;
      final notes = notesJson
          .map(
            (e) => NoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return notes;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          final data = loadStorage();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notas'),
            ),
            body: data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sticky_note_2_rounded,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'No hay notas aún',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                : _List(
                    items: data,
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AppNavigator.gotoAddNotePage(context);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Expanded(
          child: LoadingIndicator(
            indicatorType: Indicator.orbit,
          ),
        );
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    super.key,
    required this.items,
  });

  final List<NoteModel> items;

  NoteModel createEmptyModel() {
    return NoteModel(tittle: '', text: '', date: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      items.insert(0, createEmptyModel());
      items.add(createEmptyModel());
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const _MinSpace(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              top: 15,
            ),
            child: Text(
              'Todas las notas',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          );
        }
        if (index == items.length - 1) {
          return const SizedBox(
            height: 100,
          );
        }
        return _NoteCard(item: items[index]);
      },
    );
  }
}

class _MinSpace extends StatelessWidget {
  const _MinSpace();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 15,
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.item,
  });

  final NoteModel item;

  @override
  Widget build(BuildContext context) {
    DateTime date = item.date;
    final String dateFormatted = DateFormat.yMMMMEEEEd('es').format(date);
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.3),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.tittle),
            const _MinSpace(),
            Text(capitalize(dateFormatted)),
          ],
        ),
      ),
    );
  }
}
