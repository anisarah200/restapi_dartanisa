import '../providers/database_provider.dart';

Future<void> createProductsTable() async {
  final conn = await DatabaseProvider.getConnection();
  await conn.query('''
    CREATE TABLE IF NOT EXISTS products (
      prod_id VARCHAR(10) PRIMARY KEY,
      vend_id CHAR(5),
      prod_name VARCHAR(50),
      prod_price FLOAT,
      prod_desc TEXT,
      FOREIGN KEY (vend_id) REFERENCES vendors(vend_id)
    );
  ''');
}
