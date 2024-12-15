import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart'; // Impor pustaka dotenv

class DatabaseProvider {
  static MySqlConnection? _connection;

  static Future<MySqlConnection> getConnection() async {
    if (_connection == null) {
      // Muat dotenv jika belum dimuat
      final dotenv = DotEnv()..load();

      // Gunakan instance dotenv untuk mengambil variabel lingkungan
      final settings = ConnectionSettings(
        host: dotenv['DB_HOST'] ?? 'localhost',
        port: int.parse(dotenv['DB_PORT'] ?? '3306'),
        user: dotenv['DB_USERNAME'] ?? 'root',
        password: dotenv['DB_PASSWORD'] ?? '',
        db: dotenv['DB_DATABASE'] ?? 'test_api',
      );

      _connection = await MySqlConnection.connect(settings);
    }
    return _connection!;
  }
}
