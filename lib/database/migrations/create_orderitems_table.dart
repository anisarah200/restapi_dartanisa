import '../providers/database_provider.dart';

Future<void> createOrderItemsTable() async {
  final conn = await DatabaseProvider.getConnection();
  await conn.query('''
    CREATE TABLE IF NOT EXISTS orderitems (
      order_item INT PRIMARY KEY,
      order_num INT,
      prod_id VARCHAR(10),
      quantity INT,
      size INT,
      FOREIGN KEY (order_num) REFERENCES orders(order_num),
      FOREIGN KEY (prod_id) REFERENCES products(prod_id)
    );
  ''');
  print('orderitems table migrated successfully.');
}

// Fungsi main untuk menjalankan file ini langsung
void main() async {
  await createOrderItemsTable();
}
