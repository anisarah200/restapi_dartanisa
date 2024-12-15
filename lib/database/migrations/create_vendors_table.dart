import '../providers/database_provider.dart';

Future<void> createVendorsTable() async {
  final conn = await DatabaseProvider.getConnection();
  await conn.query('''
    CREATE TABLE IF NOT EXISTS vendors (
      vend_id CHAR(5) PRIMARY KEY,
      vend_name VARCHAR(50),
      vend_address TEXT,
      vend_kota TEXT,
      vend_state VARCHAR(5),
      vend_zip VARCHAR(7),
      vend_country VARCHAR(25)
    );
  ''');
}
