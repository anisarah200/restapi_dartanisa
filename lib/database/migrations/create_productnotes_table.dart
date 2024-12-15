import '../providers/database_provider.dart';

Future<void> createProductNotesTable() async {
  final conn = await DatabaseProvider.getConnection();
  await conn.query('''
    CREATE TABLE IF NOT EXISTS productnotes (
      note_id CHAR(5) PRIMARY KEY,
      prod_id VARCHAR(10),
      note_date DATE,
      note_text TEXT,
      FOREIGN KEY (prod_id) REFERENCES products(prod_id)
    );
  ''');
}
