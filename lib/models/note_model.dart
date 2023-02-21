class NoteModel {
  final String tittle;
  final String text;
  final DateTime date;

  const NoteModel({
    required this.tittle,
    required this.text,
    required this.date,
  });

  Map<String, Object> toJson() {
    return {
      'tittle': tittle,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      date: DateTime.parse(
        map['date'] as String,
      ),
      text: map['text'] as String,
      tittle: map['tittle'] as String,
    );
  }
}
