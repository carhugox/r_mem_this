import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:r_mem_this/pages/notes_main_page.dart';

Future<void> main() async {
  initializeDateFormatting();
  runApp(const MyApp());
  await Alarm.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesMainPage(),
    );
  }
}
