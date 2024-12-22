import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class CustomersController {
  // GET /customers
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT 
          cust_id, cust_name, cust_address, cust_city, 
          cust_state, cust_zip, cust_country, cust_tel 
        FROM customers
      ''');

      // Memetakan hasil query ke JSON
      final customers = results
          .map((row) => {
                'cust_id': row[0],
                'cust_name': row[1],
                'cust_address': row[2],
                'cust_city': row[3],
                'cust_state': row[4],
                'cust_zip': row[5],
                'cust_country': row[6],
                'cust_tel': row[7],
              })
          .toList();

      return Response.ok(
        jsonEncode(
            {'message': 'Customers fetched successfully', 'data': customers}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching customers: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch customers'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /customers
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // Validasi input
      final requiredFields = [
        'cust_id',
        'cust_name',
        'cust_address',
        'cust_city',
        'cust_state',
        'cust_zip',
        'cust_country',
        'cust_tel'
      ];
      for (var field in requiredFields) {
        if (data[field] == null) {
          return Response(
            400,
            body: jsonEncode({'error': 'Field $field is required'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }

      final conn = await DatabaseProvider.getConnection();
      await conn.query(
        '''
        INSERT INTO customers (cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_tel)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          data['cust_id'],
          data['cust_name'],
          data['cust_address'],
          data['cust_city'],
          data['cust_state'],
          data['cust_zip'],
          data['cust_country'],
          data['cust_tel']
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Customer created successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create customer'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /customers/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // Validasi input
      final requiredFields = [
        'cust_name',
        'cust_address',
        'cust_city',
        'cust_state',
        'cust_zip',
        'cust_country',
        'cust_tel'
      ];
      for (var field in requiredFields) {
        if (data[field] == null) {
          return Response(
            400,
            body: jsonEncode({'error': 'Field $field is required'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }

      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        '''
        UPDATE customers 
        SET cust_name = ?, cust_address = ?, cust_city = ?, cust_state = ?, cust_zip = ?, cust_country = ?, cust_tel = ?
        WHERE cust_id = ?
        ''',
        [
          data['cust_name'],
          data['cust_address'],
          data['cust_city'],
          data['cust_state'],
          data['cust_zip'],
          data['cust_country'],
          data['cust_tel'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(
          404,
          body: jsonEncode({'error': 'Customer not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Customer updated successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update customer'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // DELETE /customers/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        'DELETE FROM customers WHERE cust_id = ?',
        [id],
      );

      if (result.affectedRows == 0) {
        return Response(
          404,
          body: jsonEncode({'error': 'Customer not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Customer deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete customer'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
