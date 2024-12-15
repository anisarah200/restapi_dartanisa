import '../providers/database_provider.dart';

Future<void> createCustomersTable() async {
  final conn = await DatabaseProvider.getConnection();

  await conn.query('''
    CREATE TABLE IF NOT EXISTS customers (
      cust_id CHAR(5) PRIMARY KEY,
      cust_name VARCHAR(50),
      cust_address VARCHAR(50),
      cust_city VARCHAR(20),
      cust_state VARCHAR(5),
      cust_zip VARCHAR(7),
      cust_country VARCHAR(25),
      cust_tel VARCHAR(15)
    );
  ''');
}
