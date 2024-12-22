import 'dart:convert';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class VendorsController {
  // GET /vendors
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT vend_id, vend_name, vend_address, vend_kota, vend_state, vend_zip, vend_country 
        FROM vendors
      ''');

      // Debugging untuk memeriksa tipe data
      for (var row in results) {
        print('Row: $row');
        for (var i = 0; i < row.length; i++) {
          print('Row[$i]: ${row[i]}');
          print('Row[$i] Type: ${row[i]?.runtimeType}');
        }
      }

      final vendors = results.map((row) {
        // Konversi Blob ke String jika diperlukan
        final vendAddress = row[2] is Uint8List
            ? utf8.decode(row[2]) // Konversi jika Blob
            : row[2]?.toString(); // Jika String, gunakan langsung

        final vendKota = row[3] is Uint8List
            ? utf8.decode(row[3]) // Konversi jika Blob
            : row[3]?.toString(); // Jika String, gunakan langsung

        return {
          'vend_id': row[0],
          'vend_name': row[1],
          'vend_address': vendAddress,
          'vend_kota': vendKota,
          'vend_state': row[4],
          'vend_zip': row[5],
          'vend_country': row[6],
        };
      }).toList();

      return Response.ok(
        jsonEncode(vendors),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching vendors: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch vendors'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /vendors
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['vend_id'] == null || data['vend_name'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      await conn.query(
        '''
        INSERT INTO vendors (vend_id, vend_name, vend_address, vend_kota, vend_state, vend_zip, vend_country) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          data['vend_id'],
          data['vend_name'],
          data['vend_address'],
          data['vend_kota'],
          data['vend_state'],
          data['vend_zip'],
          data['vend_country'],
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Vendors berhasil dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating vendor: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'vendors gagal dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /vendors/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['vend_name'] == null || data['vend_address'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        '''
        UPDATE vendors 
        SET vend_name = ?, vend_address = ?, vend_kota = ?, vend_state = ?, vend_zip = ?, vend_country = ? 
        WHERE vend_id = ?
        ''',
        [
          data['vend_name'],
          data['vend_address'],
          data['vend_kota'],
          data['vend_state'],
          data['vend_zip'],
          data['vend_country'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(404,
            body: jsonEncode({'error': 'Vendor tidak di temukan'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Vendor berhasil di updated'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating vendor: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'vendos gagal di updated'}),
      );
    }
  }

  // DELETE /vendors/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result =
          await conn.query('DELETE FROM vendors WHERE vend_id = ?', [id]);

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Vendor not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Vendors berhasil di deleted'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting vendor: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'vendor gagal di delete'}),
      );
    }
  }
}
