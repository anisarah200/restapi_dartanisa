class ProductNote {
  final String noteId;
  final String prodId;
  final DateTime noteDate;
  final String noteText;

  ProductNote({
    required this.noteId,
    required this.prodId,
    required this.noteDate,
    required this.noteText,
  });

  factory ProductNote.fromJson(Map<String, dynamic> json) => ProductNote(
        noteId: json['note_id'],
        prodId: json['prod_id'],
        noteDate: DateTime.parse(json['note_date']),
        noteText: json['note_text'],
      );

  Map<String, dynamic> toJson() => {
        'note_id': noteId,
        'prod_id': prodId,
        'note_date': noteDate.toIso8601String(),
        'note_text': noteText,
      };
}
