import 'dart:convert';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class ProductNotesController {
  // GET /productnotes
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT note_id, prod_id, note_date, note_text 
        FROM productnotes
      ''');

      final productNotes = results.map((row) {
        final noteText = row[3];

        final textAsString = noteText is Uint8List
            ? utf8.decode(noteText)
            : noteText?.toString();

        return {
          'note_id': row[0],
          'prod_id': row[1],
          'note_date': row[2]?.toString(),
          'note_text': textAsString,
        };
      }).toList();

      return Response.ok(
        jsonEncode(productNotes),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching product notes: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch product notes'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /productnotes
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      final conn = await DatabaseProvider.getConnection();
      await conn.query(
        '''INSERT INTO productnotes (note_id, prod_id, note_date, note_text) 
           VALUES (?, ?, ?, ?)''',
        [
          data['note_id'],
          data['prod_id'],
          data['note_date'],
          data['note_text'],
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Product note created successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating product note: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create product note'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /productnotes/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        '''UPDATE productnotes 
           SET prod_id = ?, note_date = ?, note_text = ? 
           WHERE note_id = ?''',
        [
          data['prod_id'],
          data['note_date'],
          data['note_text'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Product note not found'}));
      }

      return Response.ok(
        jsonEncode({'message': 'Product note updated successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating product note: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update product note'}),
      );
    }
  }

  // DELETE /productnotes/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        'DELETE FROM productnotes WHERE note_id = ?',
        [id],
      );

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Product note not found'}));
      }

      return Response.ok(
        jsonEncode({'message': 'Product note deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting product note: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete product note'}),
      );
    }
  }
}
