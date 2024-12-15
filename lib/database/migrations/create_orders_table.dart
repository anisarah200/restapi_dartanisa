import '../providers/database_provider.dart';


Future<void> createOrdersTable() async {
  final conn = await DatabaseProvider.getConnection();

  await conn.query('''
    CREATE TABLE IF NOT EXISTS orders (
      order_num INT PRIMARY KEY,
      order_date DATE,
      cust_id CHAR(5),
      FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
    );
  ''');
}
