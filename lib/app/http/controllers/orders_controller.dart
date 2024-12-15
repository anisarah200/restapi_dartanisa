import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class OrdersController {
  // GET /orders
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT order_num, order_date, cust_id 
        FROM orders
      ''');

      final orders = results
          .map((row) => {
                'order_num': row[0],
                'order_date': row[1].toString(),
                'cust_id': row[2],
              })
          .toList();

      return Response.ok(
        jsonEncode(orders),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching orders: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch orders'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /orders
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['order_num'] == null || data['order_date'] == null || data['cust_id'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      await conn.query(
        '''
        INSERT INTO orders (order_num, order_date, cust_id) 
        VALUES (?, ?, ?)
        ''',
        [
          data['order_num'],
          data['order_date'],
          data['cust_id']
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Order created successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating order: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create order'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /orders/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['order_date'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        '''
        UPDATE orders 
        SET order_date = ? 
        WHERE order_num = ?
        ''',
        [
          data['order_date'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Order not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Order updated successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating order: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update order'}),
      );
    }
  }

  // DELETE /orders/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query('DELETE FROM orders WHERE order_num = ?', [id]);

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Order not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Order deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting order: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete order'}),
      );
    }
  }
}
