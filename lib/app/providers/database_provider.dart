// import 'package:mysql1/mysql1.dart';
// import 'package:dotenv/dotenv.dart' as dotenv;

// class DatabaseProvider {
//   static MySqlConnection? _connection;

//   static Future<MySqlConnection> getConnection() async {
//     if (_connection == null) {
//       final settings = ConnectionSettings(
//         host: dotenv.env['DB_HOST'] ?? 'localhost',
//         port: int.parse(dotenv.env['DB_PORT'] ?? '3306'),
//         user: dotenv.env['DB_USERNAME'] ?? 'root',
//         password: dotenv.env['DB_PASSWORD'], // Password dari file .env
//         db: dotenv.env['DB_DATABASE'] ?? 'vania',
//       );

//       _connection = await MySqlConnection.connect(settings);
//     }

//     return _connection!;
//   }
// }
