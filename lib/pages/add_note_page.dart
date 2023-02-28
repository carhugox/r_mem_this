import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:r_mem_this/models/note_model.dart';
import 'package:r_mem_this/navigator/app_navigator.dart';
import 'package:r_mem_this/utils/string_uitils.dart';

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
  bool _showDateTimePicker = false;
  DateTime alarmDate = DateTime.now();
  String alarmDateString = '';

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

  Future<void> _saveNote(NoteModel note, DateTime date) async {
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
    if (alarmDateString.isNotEmpty) {
      final dateTime = DateTime.parse(alarmDateString);
      final alarmSettings = AlarmSettings(
        dateTime: dateTime,
        assetAudioPath: 'assets/sample.mp3',
        loopAudio: true,
        notificationTitle: capitalize(note.tittle),
        notificationBody: 'Regresa a la app para finalizar la alarma.',
        enableNotificationOnKill: true,
      );
      final res = await Alarm.set(settings: alarmSettings);
      if (res) {
        print('alarm set');
      }
    }
    AppNavigator.gotoMainPage(context);
  }

  @override
  Widget build(BuildContext context) {
    final String dateFormatted =
        DateFormat('yyyy.MMMMM.dd GGG hh:mm aaa', 'es').format(alarmDate);
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Row(
              children: [
                const Text("Crear recordatorio"),
                Switch(
                  value: _showDateTimePicker,
                  onChanged: (bool value) {
                    setState(() {
                      _showDateTimePicker = value;
                      if (!value) {
                        alarmDateString = '';
                        alarmDate = DateTime.now();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          if (_showDateTimePicker)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: DateTimePicker(
                      initialValue: alarmDateString,
                      type: DateTimePickerType.dateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      dateHintText: "Fecha",
                      icon: const Icon(Icons.alarm),
                      dateMask: 'dd/MM/yyyy HH:mm',
                      onChanged: (value) {
                        print('AAAAAAAAAAA $value');
                        setState(() {
                          alarmDateString = value;
                          alarmDate = DateTime.parse(value);
                        });
                      },
                    ),
                  ),
                  Text(dateFormatted),
                  TextButton(
                    onPressed: () {
                      final date = DateTime.now()
                          .add(
                            Duration(minutes: 1),
                          )
                          .toIso8601String();
                      print('AAAAAAAAAAA $date');
                      setState(() {
                        alarmDateString = date;
                        alarmDate = DateTime.parse(date);
                      });
                    },
                    child: const Text("1 min"),
                  )
                ],
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
              hasAlarm: _showDateTimePicker,
            );
            await _saveNote(note, date);
          }
        },
        tooltip: 'Agregar',
        child: const Icon(Icons.save),
      ),
    );
  }
}
