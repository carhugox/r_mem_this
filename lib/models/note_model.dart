class NoteModel {
  final String tittle;
  final String text;
  final DateTime date;
  final bool hasAlarm;

  const NoteModel({
    required this.tittle,
    required this.text,
    required this.date,
    required this.hasAlarm,
  });

  Map<String, Object> toJson() {
    return {
      'tittle': tittle,
      'text': text,
      'date': date.toIso8601String(),
      'hasAlarm': hasAlarm,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      date: DateTime.parse(
        map['date'] as String,
      ),
      text: map['text'] as String,
      tittle: map['tittle'] as String,
      hasAlarm: map['hasAlarm'] as bool,
    );
  }
}
